FROM node:14
WORKDIR /app
COPY . .
RUN npm install
RUN npm i -g pnpm
EXPOSE 3000
CMD ["pnpm", "start"]
