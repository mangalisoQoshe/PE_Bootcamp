from flask import Flask, jsonify, request

app = Flask(__name__)

students = [
    {"id": 1, "name": "Alice", "age": 18},
    {"id": 2, "name": "Bob", "age": 19},
    {"id": 3, "name": "Charlie", "age": 20},
    {"id": 4, "name": "Diana", "age": 18},
    {"id": 5, "name": "Ethan", "age": 21},
    {"id": 6, "name": "Fiona", "age": 19},
    {"id": 7, "name": "George", "age": 22},
    {"id": 8, "name": "Hannah", "age": 20},
    {"id": 9, "name": "Ian", "age": 18},
    {"id": 10, "name": "Julia", "age": 21},
]



@app.route("/")
def home():
    return "<h1>Welcome to the Students API</h1>"


@app.route("/api/v1/students",methods=['GET'])
def get_students():
    return jsonify(students)


@app.route("/api/v1/students/<int:student_id>",methods=["GET"])
def get_student(student_id):
    for student in students:
        if student["id"] == student_id:
            return jsonify(student)

    return jsonify({"error": "Student not found"}), 404

@app.route("/api/v1/students",methods=["POST"])      
def create_student():
    data = request.get_json()
    if not data or "name" not in data or "age" not in data:
        return jsonify({"error": "Name and Age are required"}), 400
    
    new_student = {
        "id": max(st["id"] for st in students) + 1 if students else 1,
        "name": data["name"],
        "age": data["age"]
    }

    students.append(new_student)
    return jsonify(new_student), 201


@app.route("/api/v1/students/<int:student_id>",methods=["PUT"])
def update_student(student_id):
    data = request.get_json()
    student = next((st for st in students if st["id"] == student_id), None)

    if not student:
        return jsonify({"error": "Student not found."}), 404
    
    student["name"] = data.get("name", student["name"])
    student["age"] = data.get("age", student["age"])
    
    return jsonify(student)

@app.route("/api/v1/students/<int:student_id>",methods=["DELETE"])
def delete_student(student_id):
    global students
    student = next((st for st in students if st["id"] == student_id), None)

    if not student:
        return jsonify({"error": "Student not found."}), 404

    students = [st for st in students if st["id"] != student_id]
    return jsonify({"message": "User deleted"})

 
@app.route("/api/v1/health", methods=["GET"])
def health_check():
    return {"status": "healthy"}, 200

if __name__ == "__main__":
    app.run(debug=True)