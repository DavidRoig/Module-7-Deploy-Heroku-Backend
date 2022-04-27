mkdir -p ./dist/public

cd ../heroku-frontend
npm install
npm run build
cp -r ./dist/. ../heroku-backend/dist/public
