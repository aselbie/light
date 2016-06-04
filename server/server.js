import Koa from 'koa'
import path from 'path'
import convert from 'koa-convert'
import webpack from 'webpack'
import webpackConfig from '../webpack.config'
import historyApiFallback from 'koa-connect-history-api-fallback'
import serve from 'koa-static'
import webpackDevMiddleware from './middleware/webpack-dev'
import webpackHMRMiddleware from './middleware/webpack-hmr'

const app = new Koa()
const env = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development'

app.use(convert(historyApiFallback()))

if (env === 'development') {
  const compiler = webpack(webpackConfig)

  app.use(webpackDevMiddleware(compiler, 'http://localhost:3000/'))
  app.use(webpackHMRMiddleware(compiler))
  app.use(convert(serve(path.join(__dirname, '../client'))))
} else {
  app.use(convert(serve(path.join(__dirname, '../dist'))))
}

app.listen( process.env.PORT || 3000 )
