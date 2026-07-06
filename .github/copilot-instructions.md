## Repo overview (big picture)

- This repository is primarily a small static marketing site (root `index.html`, `styles.css`, `assets/`) plus a collection of Python scraper & outreach scripts in `scraper/` that operate on CSV data in `data/`.
- Core data flow (simple, linear):
  - `data/school_websites_normalised.csv` → `scraper/scrape_all.py` (uses `fetch_html.py`) → `data/school_emails_raw.csv`
  - Cleaning steps in `scraper/` (e.g. `clean_emails.py`, `clean_final_dataset.py`) produce `data/school_emails_final_clean.csv`
  - `scraper/send_daily_emails.py` reads `school_emails_final_clean.csv`, sends emails (Microsoft Graph API) and appends to `data/email_send_log.csv`.

## Important components and where to look

- scraper/fetch_html.py — resilient HTTP fetch with a browser-like UA and timeout; returns None on failure. Used by scraping scripts.
- scraper/extract_emails.py — regex-based extraction, dedupes, filters image/file-like false positives. Good canonical example of how emails are detected.
- scraper/scrape_all.py — orchestrates bulk scraping and writes `data/school_emails_raw.csv`.
- scraper/send_daily_emails.py — the outbound engine. Example behaviours:
  - Hard-coded path setup using absolute SCRIPT_DIR constant (note: this file currently contains credentials). 
  - `--test` flag triggers a single test send using Graph API logic.
  - Scheduling: `schedule_times()` picks morning/late windows and will sleep until send times.
  - Logging: writes `data/email_send_log.csv` with fields [SchoolWebsite, FinalEmail, SentTimestamp, Status].

## Developer workflows / common commands

- Run the full scrape (fast, single-process):
  - `python3 scraper/scrape_all.py`
- Clean / normalise steps are separate scripts under `scraper/` — open them to see expected CSV columns (e.g. `SchoolWebsite`, `FinalEmail`).
- Run the email sender in dry/test mode:
  - `python3 scraper/send_daily_emails.py --test` (uses Graph API path inside the script)
- Run the daily send (be careful — will actually send emails):
  - `python3 scraper/send_daily_emails.py`

Notes: there is no project-wide virtualenv or requirements file in the repo. Expect dependencies: `requests`, `pandas` for scraping/processing. Create and use a venv and install those before running scripts.

## Project-specific patterns & conventions

- CSV-first workflow: scripts read/write CSVs in `data/`. Column names are significant (e.g. `SchoolWebsite`, `FinalEmail`, `Emails`). When editing scripts, preserve these headers.
- Small, single-purpose scripts: many scripts do one stage (fetch, extract, merge, clean, send). Prefer adding new scripts that follow the same thin, procedural style.
- Failure-tolerant scraping: `fetch_html()` returns `None` on any network error (scripts check for falsy HTML and log to `data/scrape_errors.log`). Keep that contract when reusing fetch.
- Simple dedupe/filter rules live in `extract_emails.py` (regex + blacklist of file extensions). If you need to tighten/loosen extraction, change this module only and re-run scraping.

## Integration points & external systems

- Microsoft Graph API used in `scraper/send_daily_emails.py` (token endpoint + `users/{SENDER}/sendMail`). Credentials (TENANT_ID, CLIENT_ID, CLIENT_SECRET, SENDER) are currently defined in the file — treat these as secrets.
- Netlify form: `index.html` contains a `data-netlify="true"` form. This is a static-site integration point (no repo-side code required).
- Cloudflare Web Analytics: `index.html` includes a Cloudflare beacon token.

## Security & sensitive-data notes (actionable)

- `scraper/send_daily_emails.py` currently contains live-looking credentials. Do not commit real secrets. If you find credentials left in code, prefer to:
  1. Move them to environment variables and read via `os.environ`.
  2. Add a `.env.example` showing expected names (do not commit real values).
  3. Rotate any credentials that were accidentally committed.

## Examples to reference in code changes

- CSV header examples: `data/school_emails_final_clean.csv` rows are read by `send_daily_emails.load_candidates()` and expected as `row['SchoolWebsite']` and `row['FinalEmail']`.
- HTTP fetch pattern: use the `HEADERS` UA and the `try/except` style from `fetch_html.py`.
- Email parsing: use `extract_emails_from_html()` regex + post-filtering (see `extract_emails.py`).

## When modifying or adding features — quick checklist for an AI agent

1. Preserve CSV header contracts (search for `SchoolWebsite`, `FinalEmail`, `Emails`).
2. Reuse `fetch_html.py` and `extract_emails.py` rather than duplicating fetch/parsing logic.
3. If changing scheduled/sending behaviour, keep `--test` parity so maintainers can validate without sending live mail.
4. Avoid committing credentials; prefer env vars and document how to set them in the repo README or a `.env.example`.

---
If any section is unclear or you'd like me to add a small `requirements.txt`, `.env.example`, or a short script to validate CSV contracts, tell me which one and I will add it.
