from flask import jsonify

def register_error_handler(app):
    @app.errorhandler(500)
    def handle_500(e):
        app.logger.error(f"500 error: {e}", exc_info=True)
        return jsonify({"error": "Internal server error"}), 500

