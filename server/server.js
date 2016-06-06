import Koa from 'koa'
import path from 'path'
import convert from 'koa-convert'
import webpack from 'webpack'
import webpackConfig from '../webpack.config'
import historyApiFallback from 'koa-connect-history-api-fallback'
import serve from 'koa-static'
import webpackDevMiddleware from './middleware/webpack-dev'
import webpackHMRMiddleware from './middleware/webpack-hmr'
import { Server } from 'ws'

const app = new Koa()

app.use(convert(historyApiFallback()))

if (process.env.NODE_ENV === 'development') {
  const compiler = webpack(webpackConfig)

  app.use(webpackDevMiddleware(compiler, 'http://localhost:3000/'))
  app.use(webpackHMRMiddleware(compiler))
  app.use(convert(serve(path.join(__dirname, '../client'))))
} else {
  app.use(convert(serve(path.join(__dirname, '../dist'))))
}

const server = app.listen( process.env.PORT || 3000 )
const wss = new Server({ server })

wss.on('connection', function connection(ws) {
  console.log('client connected')
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
  });

  ws.send('something');
});
