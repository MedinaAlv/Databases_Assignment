"""Validate and import the two selected CBS CSVs into MySQL.

Run: ./venv/bin/python import_cbs.py [--validate-only]
"""

import argparse
import csv
import os
from decimal import Decimal, InvalidOperation
from pathlib import Path

import pymysql
from dotenv import load_dotenv


ROOT = Path(__file__).resolve().parent
FINANCIAL_CSV = ROOT / "data/financial_position_age_sex_cbs_86135ENG.csv"
HOUSING_CSV = ROOT / "data/housing_costs_households_cbs_84488ENG.csv"


def read_rows(path):
    with path.open(encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)
        rows = []
        for line_number, row in enumerate(reader, start=2):
            if next(iter(row.values())) == "Source: CBS." and not row.get("Periods"):
                continue
            if not row.get("Periods"):
                raise ValueError(f"{path.name}:{line_number}: missing period")
            rows.append(row)
    return rows


def decimal_value(raw, label):
    if raw is None or raw.strip() in ("", "."):
        return None
    try:
        return Decimal(raw.replace(",", ""))
    except InvalidOperation as error:
        raise ValueError(f"Invalid number for {label}: {raw!r}") from error


def unique_keys(rows, columns, name):
    keys = [tuple(row[column] for column in columns) for row in rows]
    if len(keys) != len(set(keys)):
        raise ValueError(f"{name}: duplicate observation key")
    if len(rows) < 50:
        raise ValueError(f"{name}: only {len(rows)} observations; at least 50 required")


def parse_financial():
    rows = read_rows(FINANCIAL_CSV)
    unique_keys(rows, ("Characteristic persons", "Sex", "Periods"), "Financial CSV")
    periods = {}
    observations = []
    for row in rows:
        raw_period = row["Periods"]
        year = int(raw_period.removesuffix("*"))
        preliminary = raw_period.endswith("*")
        if year in periods and periods[year] != preliminary:
            raise ValueError(f"Inconsistent preliminary status for {year}")
        periods[year] = preliminary
        observations.append((
            row["Characteristic persons"], row["Sex"], year,
            decimal_value(row["Equivalised income Number of persons (x\xa01\xa0000)"], "people"),
            decimal_value(row["Mean equivalised income (1\xa0000\xa0euro)"], "equivalised income"),
            decimal_value(row["Personal income Number of persons with income (x\xa01\xa0000)"], "people with income"),
            decimal_value(row["Mean personal income (1\xa0000\xa0euro)"], "personal income"),
            decimal_value(row["Median development purchasing power (%)"], "purchasing power"),
            decimal_value(row["Persons economically independent (%)"], "economic independence"),
            decimal_value(row["Persons in poverty (%)"], "poverty"),
        ))
    return periods, observations


def parse_housing():
    rows = read_rows(HOUSING_CSV)
    unique_keys(rows, ("Owner or tenant", "Dwelling characteristics", "Accuracy", "Periods", "Region"), "Housing CSV")
    regions = {}
    observations = []
    for row in rows:
        region = row["Region"]
        region_type = "country" if region == "The Netherlands" else "province" if region.endswith(" (PV)") else None
        if region_type is None:
            raise ValueError(f"Unsupported region label: {region!r}")
        regions[region] = region_type
        observations.append((
            region, row["Owner or tenant"], row["Dwelling characteristics"],
            row["Accuracy"], int(row["Periods"]),
            decimal_value(row["Housing costs Total housing costs (euros)"], "housing costs"),
            decimal_value(row["Housing cost ratio (%)"], "housing cost ratio"),
        ))
    return regions, observations


def import_rows(periods, financial, regions, housing):
    load_dotenv(ROOT / ".env")
    connection = pymysql.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        database=os.environ["DB_NAME"],
        charset="utf8mb4",
        autocommit=False,
    )
    try:
        with connection.cursor() as cursor:
            for statement in (ROOT / "cbs_observations.sql").read_text().split(";"):
                statement = statement.strip()
                if statement:
                    cursor.execute(statement)
            cursor.executemany(
                "INSERT INTO CBS_Region (region_name, region_type) VALUES (%s, %s) "
                "ON DUPLICATE KEY UPDATE region_type = VALUES(region_type)",
                list(regions.items()),
            )
            cursor.executemany(
                "INSERT INTO CBS_Financial_Period (report_year, is_preliminary) VALUES (%s, %s) "
                "ON DUPLICATE KEY UPDATE is_preliminary = VALUES(is_preliminary)",
                list(periods.items()),
            )
            cursor.executemany(
                "INSERT INTO CBS_Financial_Observation VALUES (" + ", ".join(["%s"] * 10) + ") "
                "ON DUPLICATE KEY UPDATE "
                "people_thousands = VALUES(people_thousands), "
                "mean_equivalised_income_thousand_eur = VALUES(mean_equivalised_income_thousand_eur), "
                "people_with_income_thousands = VALUES(people_with_income_thousands), "
                "mean_personal_income_thousand_eur = VALUES(mean_personal_income_thousand_eur), "
                "median_purchasing_power_change_pct = VALUES(median_purchasing_power_change_pct), "
                "economically_independent_pct = VALUES(economically_independent_pct), "
                "in_poverty_pct = VALUES(in_poverty_pct)",
                financial,
            )
            cursor.executemany(
                "INSERT INTO CBS_Housing_Cost_Observation VALUES (" + ", ".join(["%s"] * 7) + ") "
                "ON DUPLICATE KEY UPDATE "
                "mean_monthly_total_housing_cost_eur = VALUES(mean_monthly_total_housing_cost_eur), "
                "housing_cost_ratio_pct = VALUES(housing_cost_ratio_pct)",
                housing,
            )
            for table, expected in (("CBS_Financial_Observation", len(financial)), ("CBS_Housing_Cost_Observation", len(housing))):
                cursor.execute(f"SELECT COUNT(*) FROM {table}")
                actual = cursor.fetchone()[0]
                if actual != expected:
                    raise ValueError(f"{table}: expected {expected} rows, found {actual}")
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        connection.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--validate-only", action="store_true", help="Check CSVs without connecting to MySQL")
    args = parser.parse_args()
    periods, financial = parse_financial()
    regions, housing = parse_housing()
    print(f"Validated {len(financial)} financial and {len(housing)} housing observations.")
    if not args.validate_only:
        import_rows(periods, financial, regions, housing)
        print("Imported into MySQL; rerunning the command updates the same observation keys.")


if __name__ == "__main__":
    main()
