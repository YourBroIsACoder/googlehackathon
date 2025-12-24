# 🚀 Deploy to Vercel Guide

## Prerequisites
1. **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
2. **Vercel CLI**: Install globally with `npm i -g vercel`
3. **Flutter Web Build**: Your app must build successfully for web

## 🔧 Deployment Steps

### 1. Build Your Flutter Web App
```bash
flutter build web --release
```

### 2. Login to Vercel
```bash
vercel login
```

### 3. Deploy to Vercel
```bash
# From your project root directory
vercel

# Follow the prompts:
# - Set up and deploy? Y
# - Which scope? (your account)
# - Link to existing project? N
# - Project name: civic-complaint-platform
# - Directory: ./
# - Override settings? N
```

### 4. Production Deployment
```bash
vercel --prod
```

## 📋 Configuration Files

### `vercel.json`
```json
{
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "framework": null,
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### `.vercelignore`
- Excludes unnecessary files from deployment
- Keeps only the web build output

## 🌐 Environment Variables

Set these in Vercel Dashboard → Project → Settings → Environment Variables:

1. **Firebase Config** (if needed):
   - `FIREBASE_API_KEY`
   - `FIREBASE_PROJECT_ID`
   - `FIREBASE_APP_ID`

2. **AI Config**:
   - `GEMINI_API_KEY`

## 🔄 Automatic Deployments

### Connect Git Repository
1. Go to Vercel Dashboard
2. Import your GitHub/GitLab repository
3. Vercel will auto-deploy on every push to main branch

### Manual Deployments
```bash
# Deploy current state
vercel

# Deploy to production
vercel --prod
```

## 🛠️ Troubleshooting

### Build Errors
- Ensure `flutter build web` works locally
- Check Flutter web dependencies in `pubspec.yaml`
- Verify no platform-specific code in web build

### Routing Issues
- The `vercel.json` rewrites handle Flutter routing
- All routes redirect to `index.html` for client-side routing

### Performance
- Use `--release` flag for production builds
- Enable web renderer: `flutter build web --web-renderer canvaskit`

## 📱 Testing Your Deployment

1. **Local Testing**:
   ```bash
   flutter build web --release
   cd build/web
   python -m http.server 8000
   ```

2. **Vercel Preview**: Each deployment gets a preview URL

3. **Production**: Your custom domain or vercel.app URL

## 🎉 Your App is Live!

Once deployed, your civic complaint platform will be accessible worldwide at:
- **Preview**: `https://civic-complaint-platform-xxx.vercel.app`
- **Production**: Your custom domain

### Features Available on Web:
✅ Firebase Authentication  
✅ Firestore Database  
✅ AI Assistant (Gemini API)  
✅ Real-time Updates  
✅ Responsive Design  
✅ PWA Capabilities  

Your civic platform is now ready to serve communities globally! 🌍