import WebpackDevMiddleware from 'webpack-dev-middleware'
import applyExpressMiddleware from '../lib/apply-express-middleware'
import path from 'path'

export default function (compiler, publicPath) {
  const middleware = WebpackDevMiddleware(compiler, {
    publicPath,
    contentBase: path.join(__dirname, '../../client'),
    hot: true,
    quiet: false,
    noInfo: false,
    lazy: false,
    stats: true
  })

  return async function koaWebpackDevMiddleware (ctx, next) {
    let hasNext = await applyExpressMiddleware(middleware, ctx.req, {
      end: (content) => (ctx.body = content),
      setHeader: function () {
        ctx.set.apply(ctx, arguments)
      }
    })

    if (hasNext) {
      await next()
    }
  }
}