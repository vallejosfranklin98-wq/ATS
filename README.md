# Deploying Field & Roster (NBC ATS + Leave)

Everything lives on GitHub now — the code is hosted with **GitHub Pages** and the data lives in **Supabase**. No Netlify.

## 1. Supabase — the database

*(Skip this whole section if your Supabase project from before is already running — go straight to step 2, "Add the Leave tables.")*

1. Go to https://supabase.com → sign in → **New project**.
2. Pick a name (e.g. `nbc-ats`), set a database password (save it somewhere), pick the region closest to you.
3. Once it's provisioned, open **SQL Editor** (left sidebar) → **New query**.
4. Paste in everything from `schema.sql` → **Run**. This creates the `applicants`, `interviews`, `vacancies`, and `settings` tables and seeds the default lookup lists.
5. Go to **Project Settings → API**. Copy the **Project URL** and the **anon public** key, and put them in `index.html` (near the top of the `<script>` block, `SUPABASE_URL` / `SUPABASE_ANON_KEY`).

## 2. Add the Leave tables

1. In Supabase **SQL Editor → New query**, paste in everything from `leave_schema.sql` → **Run**. This creates `employees`, `leave_balances`, and `leave_transactions`, plus a `leave_type` lookup list in `settings`.
2. New query again, paste in everything from `leave_data_import.sql` → **Run**. This loads the 120 employees, their per-type leave balances, and the 216 leave transactions from `2026_NBC_LEAVE_REPORT.xlsx` into those tables. It's safe to re-run — inserts are set to skip or update existing rows rather than duplicate them.

## 3. GitHub — version control *and* hosting

1. Go to https://github.com/new → create a repo (e.g. `nbc-ats`, private is fine — GitHub Pages works on private repos with a paid plan; keep it **public** if you're on GitHub's free plan and want Pages to work).
2. In the folder with `index.html`, `schema.sql`, `leave_schema.sql`, `leave_data_import.sql`, and this README:
   ```bash
   git init
   git add .
   git commit -m "ATS + Leave module"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/nbc-ats.git
   git push -u origin main
   ```
   (If you already have this repo from before, just `git add . && git commit -m "Add leave module" && git push`.)
3. On GitHub, open the repo → **Settings → Pages**.
4. Under **Build and deployment**, set **Source** to **Deploy from a branch**, **Branch** to `main`, folder `/ (root)` → **Save**.
5. GitHub gives you a live URL within a minute or two, shaped like `https://YOUR_USERNAME.github.io/nbc-ats/`.

## Done

From here, any edit you push to `main` auto-redeploys on GitHub Pages (usually live within 1–2 minutes). Data lives in Supabase, so it persists for everyone who opens the site.

### If you were on Netlify before
Your Netlify site will keep working until you delete it, but you don't need it anymore — GitHub Pages now serves the same files straight from this repo. Once you've confirmed the GitHub Pages URL works, you can delete the Netlify site from your Netlify dashboard.

### What changed with this update
- **Employees** and **Leave Records** are new sections in the sidebar, under "Leave Management."
- **Employees** shows the roster with each employee's leave balances by type (Vacation, Sick, Birthday, Bereavement, etc.), searchable by name/ID/department, with an Active/Resigned filter.
- **Leave Records** shows every filed leave (from the imported report, plus anything you file going forward) with filters by leave type and status, and an edit/delete modal.
- **Settings** has a new "Leave Type Options" list, same pattern as Status/Position/Source.

### Later, if you want it
- **Auth / login** — the Supabase tables use an "allow all" policy so anyone with the URL can read/write, same as the original ATS tables. Fine for an internal tool behind a private link; if you want real logins later, Supabase Auth plugs in cleanly and we'd tighten the row-level security policies to match.
- **Auto-recompute leave balances** — right now balances are the snapshot from the imported report, and don't automatically deduct when you approve a new leave in the app. Let me know if you want that wired up (it would need a rule for how many days each leave type grants and when balances reset/accrue).
- **Report / Archive sheets** — your original ATS workbook had empty Report and Archive tabs. Let me know what you want there and I'll add views for them.
