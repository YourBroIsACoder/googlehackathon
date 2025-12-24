@echo off
echo 🔨 Building Flutter Web App...
flutter build web --release

echo 📁 Navigating to build directory...
cd build\web

echo 🚀 Deploying static files to Vercel...
vercel --prod

echo 📁 Returning to project root...
cd ..\..

echo ✅ Deployment Complete!
echo 🌐 Check your Vercel dashboard for the live URL!