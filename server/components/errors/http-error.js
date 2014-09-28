var HttpError = function (status, message) {
    this.status = status;
    this.message = message;
    this.stack = (new Error()).stack;
}

HttpError.prototype = new Error;
module.exports = HttpError;