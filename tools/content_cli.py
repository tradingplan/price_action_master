import argparse
import json
import os

def create_course(course_id, title, description):
    filename = f"content/courses/{course_id}.json"
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    
    course_data = {
        "id": course_id,
        "title": title,
        "description": description,
        "version": 1,
        "modules": []
    }
    
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(course_data, f, indent=2, ensure_ascii=False)
    print(f"Course '{course_id}' successfully created at {filename}")

def add_module(course_id, module_id, title, description, xp):
    filename = f"content/courses/{course_id}.json"
    if not os.path.exists(filename):
        print(f"Error: Course file '{filename}' does not exist.")
        return
        
    with open(filename, 'r', encoding='utf-8') as f:
        course_data = json.load(f)
        
    # Check if module already exists
    if any(m['id'] == module_id for m in course_data.get('modules', [])):
        print(f"Error: Module '{module_id}' already exists in course '{course_id}'.")
        return
        
    new_module = {
        "id": module_id,
        "title": title,
        "description": description,
        "xpValue": xp,
        "lessons": [],
        "examples": [],
        "exercises": [],
        "quizzes": [],
        "challenges": []
    }
    
    course_data.setdefault('modules', []).append(new_module)
    
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(course_data, f, indent=2, ensure_ascii=False)
    print(f"Module '{module_id}' successfully added to course '{course_id}'.")

def add_lesson(course_id, module_id, lesson_id, title, content):
    filename = f"content/courses/{course_id}.json"
    if not os.path.exists(filename):
        print(f"Error: Course file '{filename}' does not exist.")
        return
        
    with open(filename, 'r', encoding='utf-8') as f:
        course_data = json.load(f)
        
    module = next((m for m in course_data.get('modules', []) if m['id'] == module_id), None)
    if not module:
        print(f"Error: Module '{module_id}' not found in course '{course_id}'.")
        return
        
    if any(l['id'] == lesson_id for l in module.get('lessons', [])):
        print(f"Error: Lesson '{lesson_id}' already exists in module '{module_id}'.")
        return
        
    new_lesson = {
        "id": lesson_id,
        "title": title,
        "content": content
    }
    
    module.setdefault('lessons', []).append(new_lesson)
    
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(course_data, f, indent=2, ensure_ascii=False)
    print(f"Lesson '{lesson_id}' successfully added to module '{module_id}'.")

def add_quiz(course_id, module_id, quiz_id, question, options, correct_index, explanation):
    filename = f"content/courses/{course_id}.json"
    if not os.path.exists(filename):
        print(f"Error: Course file '{filename}' does not exist.")
        return
        
    with open(filename, 'r', encoding='utf-8') as f:
        course_data = json.load(f)
        
    module = next((m for m in course_data.get('modules', []) if m['id'] == module_id), None)
    if not module:
        print(f"Error: Module '{module_id}' not found in course '{course_id}'.")
        return
        
    if any(q['id'] == quiz_id for q in module.get('quizzes', [])):
        print(f"Error: Quiz '{quiz_id}' already exists in module '{module_id}'.")
        return
        
    new_quiz = {
        "id": quiz_id,
        "question": question,
        "options": options,
        "correctIndex": correct_index,
        "explanation": explanation
    }
    
    module.setdefault('quizzes', []).append(new_quiz)
    
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(course_data, f, indent=2, ensure_ascii=False)
    print(f"Quiz '{quiz_id}' successfully added to module '{module_id}'.")

def main():
    parser = argparse.ArgumentParser(description="Price Action Master - Content CLI")
    subparsers = parser.add_subparsers(dest="command")
    
    # create-course
    p_course = subparsers.add_parser("create-course", help="Create a new course skeleton")
    p_course.add_argument("id", help="Course unique ID (lowercase, e.g. smc)")
    p_course.add_argument("title", help="Course Title")
    p_course.add_argument("desc", help="Course Description")
    
    # create-module
    p_module = subparsers.add_parser("create-module", help="Add a module to a course")
    p_module.add_argument("course_id", help="Target Course ID")
    p_module.add_argument("id", help="Module unique ID (e.g. smc_m1)")
    p_module.add_argument("title", help="Module Title")
    p_module.add_argument("desc", help="Module Description")
    p_module.add_argument("--xp", type=int, default=100, help="XP reward amount")
    
    # create-lesson
    p_lesson = subparsers.add_parser("create-lesson", help="Add a lesson to a module")
    p_lesson.add_argument("course_id", help="Target Course ID")
    p_lesson.add_argument("module_id", help="Target Module ID")
    p_lesson.add_argument("id", help="Lesson unique ID")
    p_lesson.add_argument("title", help="Lesson Title")
    p_lesson.add_argument("content", help="Lesson Body Content")
    
    # create-quiz
    p_quiz = subparsers.add_parser("create-quiz", help="Add a quiz question to a module")
    p_quiz.add_argument("course_id", help="Target Course ID")
    p_quiz.add_argument("module_id", help="Target Module ID")
    p_quiz.add_argument("id", help="Quiz unique ID")
    p_quiz.add_argument("question", help="Question text")
    p_quiz.add_argument("options", nargs="+", help="Between 2 and 4 answer choices")
    p_quiz.add_argument("correct_index", type=int, help="0-based index of correct option")
    p_quiz.add_argument("explanation", help="Explanation rationale")
    
    args = parser.parse_args()
    
    if args.command == "create-course":
        create_course(args.id, args.title, args.desc)
    elif args.command == "create-module":
        add_module(args.course_id, args.id, args.title, args.desc, args.xp)
    elif args.command == "create-lesson":
        add_lesson(args.course_id, args.module_id, args.id, args.title, args.content)
    elif args.command == "create-quiz":
        add_quiz(args.course_id, args.module_id, args.id, args.question, args.options, args.correct_index, args.explanation)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
