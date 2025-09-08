# Docsify Documentation Server - Usage Guide

This guide explains how to set up and run the Docsify documentation server for the Bizzan Cryptocurrency Exchange Platform.

## Prerequisites

Before running the documentation server, ensure you have the following installed:

- **Node.js** (version 12 or higher) - [Download here](https://nodejs.org/)
- **npm** (comes with Node.js) or **yarn**

## Quick Start

### 1. Install Docsify CLI

Install the Docsify command-line tool globally:

```bash
npm install -g docsify-cli
```

Or using yarn:

```bash
yarn global add docsify-cli
```

### 2. Navigate to Documentation Directory

```bash
cd docs
```

### 3. Serve the Documentation

Run the following command to start the local development server:

```bash
docsify serve .
```

The documentation will be available at: **http://localhost:3000**

## Alternative Port

If port 3000 is already in use, you can specify a different port:

```bash
docsify serve . --port 8080
```

## Advanced Usage

### Custom Configuration

The documentation is configured through `index.html`. Key configurations include:

- **Theme**: Vue theme with custom styling
- **Plugins**: Search, copy code, pagination, word count, zoom images, mermaid diagrams
- **Sidebar**: Auto-generated from `_sidebar.md`
- **Search**: Full-text search across all documentation

### Directory Structure

```
docs/
├── index.html              # Main Docsify configuration
├── _sidebar.md            # Navigation sidebar
├── README.md              # Homepage content
├── core/                  # Core system documentation
├── exchange/              # Exchange module docs
├── wallet/                # Wallet service docs
├── ucenter-api/           # User center API docs
├── market/                # Market data docs
├── otc-api/               # OTC trading docs
└── ...                    # Other module documentation
```

### Available Features

1. **Full-Text Search**: Search across all documentation pages
2. **Code Highlighting**: Syntax highlighting for code blocks
3. **Copy Code**: One-click code copying
4. **Image Zoom**: Click images to zoom
5. **Mermaid Diagrams**: Support for flowcharts and diagrams
6. **Reading Time**: Estimated reading time for each page
7. **Pagination**: Navigate between pages
8. **Responsive Design**: Mobile-friendly interface

## Customization

### Updating Content

1. Edit markdown files directly in their respective directories
2. The server will automatically reload changes during development
3. No build step required - Docsify renders markdown on-the-fly

### Adding New Pages

1. Create new `.md` files in appropriate directories
2. Update `_sidebar.md` to include new pages in navigation
3. Follow the existing naming conventions

### Modifying Appearance

Edit the `<style>` section in `index.html` to customize:
- Colors and themes
- Typography
- Layout spacing
- Component styling

### Plugin Configuration

Plugins are configured in the `window.$docsify` object in `index.html`:

```javascript
window.$docsify = {
  // Core settings
  name: 'Bizzan Crypto Exchange',
  loadSidebar: true,
  subMaxLevel: 3,
  
  // Plugin configurations
  search: { /* search options */ },
  copyCode: { /* copy code options */ },
  pagination: { /* pagination options */ }
}
```

## Production Deployment

### Static Hosting

Since Docsify renders markdown client-side, you can deploy the entire `docs/` folder to any static hosting service:

- **Netlify**: Drag and drop the docs folder
- **Vercel**: Connect your repository and set build directory to `docs`
- **GitHub Pages**: Enable Pages for the `docs/` folder
- **AWS S3**: Upload files to S3 bucket with static hosting
- **Nginx**: Serve the docs directory

### Server Configuration

For web servers like Nginx or Apache, ensure:

1. All requests are routed to `index.html` for SPA functionality
2. MIME types are correctly configured for `.md` files
3. CORS is properly configured if serving from different domains

### Example Nginx Configuration

```nginx
server {
    listen 80;
    server_name your-docs-domain.com;
    root /path/to/docs;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location ~* \.(md|json)$ {
        add_header Content-Type text/plain;
    }
}
```

## Development Tips

### Live Reload

The `docsify serve` command includes live reload - changes to markdown files will automatically refresh the browser.

### Debug Mode

For debugging, you can run Docsify with verbose logging:

```bash
docsify serve . --verbose
```

### Local Network Access

To access the documentation from other devices on your network:

```bash
docsify serve . --host 0.0.0.0
```

Then access via your computer's IP address: `http://YOUR_IP:3000`

## Troubleshooting

### Common Issues

1. **Port already in use**: Use `--port` flag to specify different port
2. **Page not found**: Check that markdown files exist and paths in `_sidebar.md` are correct
3. **Images not loading**: Ensure image paths are relative to the markdown file location
4. **Search not working**: Verify search plugin is loaded in `index.html`

### Performance Optimization

- Keep markdown files reasonably sized (< 100KB)
- Optimize images before including in documentation
- Use external links for large files or resources

## Support

For issues specific to this documentation setup:
1. Check the Docsify official documentation: https://docsify.js.org/
2. Review the `index.html` configuration
3. Verify all required plugins are loaded

---

**Happy documenting!** 📚
