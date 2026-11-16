#!/usr/bin/env bash
# Builds a clean, deployable copy of the site in dist/.
# Preview builds are noindex; run `./build.sh --prod` for the public launch.
# SITE_URL is the public address, without trailing slash (set by the CI from GitHub Pages).
set -euo pipefail
cd "$(dirname "$0")"

SITE_URL="${SITE_URL:-http://localhost:8765}"
SITE_URL="${SITE_URL%/}"

rm -rf dist
mkdir dist
cp -r index.html mentions-legales.html css fonts js img dist/

sed -i "s|__SITE_URL__|${SITE_URL}|g" dist/*.html

if [[ "${1:-}" != "--prod" ]]; then
    sed -i 's|<meta charset="utf-8">|<meta charset="utf-8">\n    <meta name="robots" content="noindex, nofollow">|' dist/*.html
fi

cat > dist/robots.txt <<EOF
User-agent: *
Allow: /

Sitemap: ${SITE_URL}/sitemap.xml
EOF

cat > dist/sitemap.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>${SITE_URL}/</loc>
        <lastmod>$(date +%F)</lastmod>
    </url>
    <url>
        <loc>${SITE_URL}/mentions-legales.html</loc>
        <lastmod>$(date +%F)</lastmod>
    </url>
</urlset>
EOF

echo "dist/ ready for ${SITE_URL}:"
find dist -type f | sort
