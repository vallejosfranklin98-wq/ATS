# Deploying Field & Roster (NBC ATS)

Two files, three services. No servers to manage.

## 1. Supabase — the database

1. Go to https://supabase.com → sign in → **New project**.
2. Pick a name (e.g. `nbc-ats`), set a database password (save it somewhere), pick the region closest to you.
3. Once it's provisioned, open **SQL Editor** (left sidebar) → **New query**.
4. Paste in everything from `schema.sql` → **Run**. This creates the `applicants`, `interviews`, `vacancies`, and `settings` tables and seeds the default lookup lists.
5. Go to **Project Settings → API**. Copy two values:
   - **Project URL**
   - **anon public** key

## 2. Connect the app to Supabase

1. Open `index.html` in a text editor.
2. Near the top of the `<script>` block, find:
   ```js
   const SUPABASE_URL = 'YOUR_SUPABASE_PROJECT_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Replace both with the values you copied. Save the file.

## 3. GitHub — version control

1. Go to https://github.com/new → create a repo (e.g. `nbc-ats`, private is fine).
2. On your computer, in the folder containing `index.html`, `schema.sql`, and this README:
   ```bash
   git init
   git add .
   git commit -m "Initial ATS app"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/nbc-ats.git
   git push -u origin main
   ```
   (If `git` asks you to log in, use a GitHub personal access token as the password — GitHub stopped accepting account passwords for this a while back.)

## 4. Netlify — hosting

1. Go to https://app.netlify.com → **Add new site → Import an existing project**.
2. Connect your GitHub account, pick the `nbc-ats` repo.
3. Build settings: leave **Build command** blank and **Publish directory** as `/` (this is a static site, nothing to build).
4. Click **Deploy**. Netlify gives you a live URL like `nbc-ats.netlify.app` within a minute.

## Done

From here, any edit you push to the `main` branch on GitHub auto-redeploys on Netlify. Data lives in Supabase, so it persists for everyone who opens the site.

### Later, if you want it
- **Auth / login** — right now the Supabase tables use an "allow all" policy so anyone with the URL can read/write. Fine for an internal tool behind a private link; if you want real logins later, Supabase Auth plugs in cleanly and we'd tighten the row-level security policies to match.
- **Report / Archive sheets** — your original workbook had empty Report and Archive tabs. Let me know what you want there and I'll add views for them.