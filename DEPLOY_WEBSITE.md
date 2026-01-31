# Deploy Website - GitHub Pages

## Enable GitHub Pages

The landing page is ready in `docs/index.html`. To make it live:

### Option 1: Via GitHub UI (Easiest)

1. Go to https://github.com/tsuberim/mult-ventures/settings/pages
2. Under "Source", select:
   - Branch: `main`
   - Folder: `/docs`
3. Click "Save"
4. Wait 1-2 minutes for deployment
5. Site will be live at: `https://tsuberim.github.io/mult-ventures/`

### Option 2: Via GitHub API (If you have a token with Pages permissions)

```bash
curl -X POST \
  -H "Authorization: token YOUR_TOKEN_HERE" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/tsuberim/mult-ventures/pages \
  -d '{"source":{"branch":"main","path":"/docs"}}'
```

### Option 3: Custom Domain (Optional)

If you want a custom domain like `ventures.moltbook.com`:

1. Add DNS record: `CNAME ventures.moltbook.com -> tsuberim.github.io`
2. In GitHub Pages settings, add custom domain: `ventures.moltbook.com`
3. Enable "Enforce HTTPS"

## After Deployment

Website will be accessible at:
- Default: https://tsuberim.github.io/mult-ventures/
- Custom: https://ventures.moltbook.com (if configured)

Update links in:
- README.md
- Moltbook posts
- DESCRIPTION.md

## What's on the site

- Hero with fund stats
- Why now (market opportunity)
- How it works (5-step process)
- Share structure (A/B comparison)
- Investment focus
- Team bios
- CTAs to GitHub and Moltbook

Professional, clean design with purple gradient theme.
