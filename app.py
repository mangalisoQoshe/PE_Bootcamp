from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
import os
from extensions import db
from models import Student


app = Flask(__name__)


DATABASE_URL = os.environ.get("DATABASE_URL")

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not set")

# PostgreSQL connection
app.config["SQLALCHEMY_DATABASE_URI"] = DATABASE_URL    
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)


@app.route("/")
def home():
    return "<h1>Welcome to the Students API</h1>"


@app.route("/api/v1/students",methods=['GET'])
def get_students():
    students = Student.query.all()
    return jsonify([s.to_dict() for s in students])


@app.route("/api/v1/students/<int:student_id>",methods=["GET"])
def get_student(student_id):
    student = Student.query.get_or_404(student_id)
    return jsonify(student.to_dict())

@app.route("/api/v1/students",methods=["POST"])      
def create_student():
    data = request.get_json()
    if not data or "name" not in data or "age" not in data:
        return jsonify({"error": "Name and Age are required"}), 400
    
    student = Student(name=data["name"], age=data["age"])
    db.session.add(student)
    db.session.commit()

    return jsonify(student.to_dict()), 201


@app.route("/api/v1/students/<int:student_id>",methods=["PUT"])
def update_student(student_id):
    data = request.get_json()
    student = next((st for st in students if st["id"] == student_id), None)

    if not student:
        return jsonify({"error": "Student not found."}), 404
    
    student = Student.query.get_or_404(student_id)

    if "name" in data:
        student.name = data["name"]

    if "age" in data:
        student.age = data["age"]

    db.session.commit()

    return jsonify(student.to_dict())

@app.route("/api/v1/students/<int:student_id>",methods=["DELETE"])
def delete_student(student_id):
    student = Student.query.get_or_404(student_id)
    db.session.delete(student)
    db.session.commit()
    return "", 204      

 
@app.route("/api/v1/health", methods=["GET"])
def health_check():
    return {"status": "healthy"}, 200

if __name__ == "__main__":
    app.run(debug=True)