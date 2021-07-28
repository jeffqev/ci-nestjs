FROM node:14.15.1 as base
WORKDIR /usr/src/app
COPY . .

FROM base as development
RUN npm install && npm run build

FROM base as production
ENV NODE_ENV=production
COPY --from=development /usr/src/app/dist ./dist
RUN npm install --only=production
CMD ["npm", "run", "start:prod"]