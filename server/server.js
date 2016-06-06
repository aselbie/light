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
import rethinkdbdash from 'rethinkdbdash'

const app = new Koa()
const r = rethinkdbdash()

const grid = r.db('test').table('grid')

// grid.delete().run().then( () => {
//   for (let y = 0; y < 10; y++) {
//     for (let x = 0; x < 10; x++) {
//       grid.insert({
//         id: x + '.' + y,
//         x,
//         y,
//         filled: Math.random() > .5
//       }).run()
//     }
//   }
// })

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
  ws.send(JSON.stringify({
    name: 'something'
  }))

  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
  });

  // grid.run( (err, result) => {
  //   if (err) throw err
    
  //   ws.send( 'grid' )
  // })
});
