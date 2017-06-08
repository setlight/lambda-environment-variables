module.exports.hello = (event, context, callback) => {
  const response = {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Ok!',
      method: process.env.method
    }),
  }

  callback(null, response)
}
