@echo off
REM 🚀 Flutter Web Deployment Script for Vercel (Windows)

echo 🔨 Building Flutter Web App...
flutter build web --release

echo 🚀 Deploying to Vercel...
vercel --prod

echo ✅ Deployment Complete!
echo 🌐 Your app is now live!