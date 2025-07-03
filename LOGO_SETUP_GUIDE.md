# Logo Setup Guide for Yorick Funeral Notices

This guide explains how to add your PNG logo as a favicon and for social media embeds.

## 📁 File Structure

Place your logo files in the following structure:
```
app/assets/images/
├── logo.png              # Your original PNG logo
├── favicon.ico           # Generated favicon (16x16, 32x32)
├── favicon-16x16.png     # 16x16 PNG favicon
├── favicon-32x32.png     # 32x32 PNG favicon
├── apple-touch-icon.png  # 180x180 for iOS devices
├── social-share.png      # 1200x630 for social media
└── social-share-square.png # 600x600 for Twitter cards
```

## 🎨 Image Requirements

### Favicon Files
- **favicon.ico**: 16x16 and 32x32 pixels (ICO format)
- **favicon-16x16.png**: 16x16 pixels
- **favicon-32x32.png**: 32x32 pixels
- **apple-touch-icon.png**: 180x180 pixels

### Social Media Files
- **social-share.png**: 1200x630 pixels (Open Graph/Facebook)
- **social-share-square.png**: 600x600 pixels (Twitter cards)

## 🛠️ Generation Steps

### 1. Prepare Your Logo
1. Start with your high-resolution PNG logo
2. Ensure it has a transparent background
3. Make sure it's square or can be cropped to square

### 2. Generate Favicon Files
You can use online tools or command-line tools:

#### Option A: Online Tools
- **Favicon.io**: https://favicon.io/favicon-converter/
- **RealFaviconGenerator**: https://realfavicongenerator.net/

#### Option B: Command Line (if you have ImageMagick)
```bash
# Install ImageMagick if not already installed
sudo apt-get install imagemagick

# Generate favicon files from your logo.png
convert logo.png -resize 16x16 favicon-16x16.png
convert logo.png -resize 32x32 favicon-32x32.png
convert logo.png -resize 180x180 apple-touch-icon.png
convert logo.png -resize 1200x630 social-share.png
convert logo.png -resize 600x600 social-share-square.png

# Generate ICO file (requires multiple sizes)
convert logo.png -resize 16x16 logo-16.png
convert logo.png -resize 32x32 logo-32.png
convert logo-16.png logo-32.png favicon.ico
```

### 3. Place Files in Assets Directory
```bash
# Copy all generated files to the assets directory
cp favicon.ico app/assets/images/
cp favicon-*.png app/assets/images/
cp apple-touch-icon.png app/assets/images/
cp social-share*.png app/assets/images/
```

## 🔧 Implementation

### 1. Update Application Layout
The layout file already has the basic structure. You'll need to add favicon links:

```erb
<!-- Add these lines in the <head> section of app/views/layouts/application.html.erb -->
<link rel="icon" type="image/x-icon" href="<%= asset_path('favicon.ico') %>">
<link rel="icon" type="image/png" sizes="16x16" href="<%= asset_path('favicon-16x16.png') %>">
<link rel="icon" type="image/png" sizes="32x32" href="<%= asset_path('favicon-32x32.png') %>">
<link rel="apple-touch-icon" sizes="180x180" href="<%= asset_path('apple-touch-icon.png') %>">
```

### 2. Update Social Media Meta Tags
The layout already includes social media meta tags. Update the image paths:

```erb
<!-- Update these lines in the existing social media section -->
<meta property="og:image" content="<%= asset_url('social-share.png') %>" />
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />

<meta name="twitter:image" content="<%= asset_url('social-share-square.png') %>" />
```

### 3. Add Web App Manifest (Optional)
Create `app/assets/images/site.webmanifest`:
```json
{
  "name": "Yorick Funeral Notices",
  "short_name": "Yorick",
  "description": "Buscador de avisos fúnebres en La Plata",
  "icons": [
    {
      "src": "/assets/favicon-16x16.png",
      "sizes": "16x16",
      "type": "image/png"
    },
    {
      "src": "/assets/favicon-32x32.png",
      "sizes": "32x32",
      "type": "image/png"
    },
    {
      "src": "/assets/apple-touch-icon.png",
      "sizes": "180x180",
      "type": "image/png"
    }
  ],
  "theme_color": "#0f172a",
  "background_color": "#312e81",
  "display": "standalone"
}
```

## 🧪 Testing

### 1. Test Favicon
- Open your app in different browsers
- Check browser tabs show the favicon
- Test on mobile devices

### 2. Test Social Media Embeds
- **Facebook**: Use https://developers.facebook.com/tools/debug/
- **Twitter**: Use https://cards-dev.twitter.com/validator
- **LinkedIn**: Use https://www.linkedin.com/post-inspector/

### 3. Test Open Graph
```bash
# Test locally
curl -I http://localhost:3000
# Look for og:image meta tags in the response
```

## 📱 Mobile Considerations

### iOS
- `apple-touch-icon.png` (180x180) for home screen
- No rounded corners needed (iOS adds them automatically)

### Android
- Chrome uses the largest available icon
- Consider adding 192x192 and 512x512 sizes for PWA support

## 🔍 SEO Benefits

1. **Brand Recognition**: Favicon helps users identify your site in browser tabs
2. **Social Sharing**: Proper social media images increase click-through rates
3. **Professional Appearance**: Complete favicon set shows attention to detail
4. **Mobile Experience**: Touch icons improve mobile user experience

## 🚀 Production Deployment

1. **Precompile Assets**: Ensure all images are included in asset precompilation
2. **CDN**: Consider serving images from a CDN for better performance
3. **Caching**: Set appropriate cache headers for favicon files
4. **HTTPS**: Ensure all image URLs use HTTPS in production

## 📋 Checklist

- [ ] Generate favicon.ico (16x16, 32x32)
- [ ] Generate favicon-16x16.png
- [ ] Generate favicon-32x32.png
- [ ] Generate apple-touch-icon.png (180x180)
- [ ] Generate social-share.png (1200x630)
- [ ] Generate social-share-square.png (600x600)
- [ ] Place all files in app/assets/images/
- [ ] Update application layout with favicon links
- [ ] Test favicon in different browsers
- [ ] Test social media embeds
- [ ] Test on mobile devices
- [ ] Deploy and verify in production

## 🎯 Next Steps

1. Prepare your logo file
2. Generate all required sizes using the tools mentioned
3. Place files in the assets directory
4. Update the application layout
5. Test thoroughly
6. Commit and deploy

This setup will give you a complete favicon and social media image solution for your Yorick Funeral Notices application. 