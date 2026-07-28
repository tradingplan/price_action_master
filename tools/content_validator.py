import glob
import json
import os
import sys

def validate_courses():
    course_files = glob.glob("content/courses/*.json")
    if not course_files:
        print("No course JSON files found in 'content/courses/'.")
        return True

    all_course_ids = set()
    all_module_ids = set()
    all_step_ids = set()
    has_errors = False

    print(f"Starting content validation for {len(course_files)} course files...\n")

    for filepath in course_files:
        filename = os.path.basename(filepath)
        print(f"Validating file: {filename}")
        
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
        except Exception as e:
            print(f"  [ERROR] Failed to parse JSON: {e}")
            has_errors = True
            continue

        # 1. Course validations
        course_id = data.get("id")
        if not course_id:
            print("  [ERROR] Course is missing 'id'.")
            has_errors = True
        else:
            if course_id in all_course_ids:
                print(f"  [ERROR] Duplicate course ID found: '{course_id}'")
                has_errors = True
            all_course_ids.add(course_id)

        if not data.get("title"):
            print("  [ERROR] Course is missing 'title'.")
            has_errors = True
        if not data.get("description"):
            print("  [ERROR] Course is missing 'description'.")
            has_errors = True
        if not isinstance(data.get("version"), int):
            print("  [ERROR] Course 'version' must be an integer.")
            has_errors = True

        modules = data.get("modules")
        if not isinstance(modules, list):
            print("  [ERROR] Course 'modules' must be a list.")
            has_errors = True
            continue

        # 2. Modules validation
        for idx, module in enumerate(modules):
            module_id = module.get("id")
            if not module_id:
                print(f"  [ERROR] Module index {idx} is missing 'id'.")
                has_errors = True
            else:
                if module_id in all_module_ids:
                    print(f"  [ERROR] Duplicate module ID found: '{module_id}'")
                    has_errors = True
                all_module_ids.add(module_id)

            if not module.get("title"):
                print(f"  [ERROR] Module '{module_id}' is missing 'title'.")
                has_errors = True
            if not module.get("description"):
                print(f"  [ERROR] Module '{module_id}' is missing 'description'.")
                has_errors = True
            
            xp = module.get("xpValue")
            if not isinstance(xp, int) or xp < 0:
                print(f"  [ERROR] Module '{module_id}' 'xpValue' must be a non-negative integer.")
                has_errors = True

            # Lessons
            lessons = module.get("lessons", [])
            if not isinstance(lessons, list):
                print(f"  [ERROR] Module '{module_id}' 'lessons' must be a list.")
                has_errors = True
            else:
                for l in lessons:
                    lid = l.get("id")
                    if not lid:
                        print(f"  [ERROR] Lesson is missing 'id' in module '{module_id}'.")
                        has_errors = True
                    else:
                        if lid in all_step_ids:
                            print(f"  [ERROR] Duplicate step ID: '{lid}'")
                            has_errors = True
                        all_step_ids.add(lid)
                    if not l.get("title"):
                        print(f"  [ERROR] Lesson '{lid}' is missing 'title'.")
                        has_errors = True
                    if not l.get("content"):
                        print(f"  [ERROR] Lesson '{lid}' is missing 'content'.")
                        has_errors = True

            # Examples
            examples = module.get("examples", [])
            if not isinstance(examples, list):
                print(f"  [ERROR] Module '{module_id}' 'examples' must be a list.")
                has_errors = True
            else:
                for e in examples:
                    eid = e.get("id")
                    if not eid:
                        print(f"  [ERROR] Example is missing 'id' in module '{module_id}'.")
                        has_errors = True
                    else:
                        if eid in all_step_ids:
                            print(f"  [ERROR] Duplicate step ID: '{eid}'")
                            has_errors = True
                        all_step_ids.add(eid)
                    if not e.get("title"):
                        print(f"  [ERROR] Example '{eid}' is missing 'title'.")
                        has_errors = True
                    if not e.get("description"):
                        print(f"  [ERROR] Example '{eid}' is missing 'description'.")
                        has_errors = True
                    
                    # Canvas validator
                    canvas = e.get("vectorCanvas")
                    if canvas:
                        width = canvas.get("width")
                        height = canvas.get("height")
                        if not isinstance(width, (int, float)) or width <= 0:
                            print(f"  [ERROR] Canvas in example '{eid}' must have a positive width.")
                            has_errors = True
                        if not isinstance(height, (int, float)) or height <= 0:
                            print(f"  [ERROR] Canvas in example '{eid}' must have a positive height.")
                            has_errors = True
                        elements = canvas.get("elements", [])
                        if not isinstance(elements, list):
                            print(f"  [ERROR] Canvas 'elements' must be a list in example '{eid}'.")
                            has_errors = True
                        else:
                            for el in elements:
                                el_type = el.get("type")
                                if el_type not in ["line", "dotted_line", "circle", "text", "candle"]:
                                    print(f"  [ERROR] Invalid element type '{el_type}' in example '{eid}'.")
                                    has_errors = True
                                
                                # Coordinate bounds validation (0.0 to 1.0 relative coords)
                                for coord_name in ["x1", "y1", "x2", "y2", "cx", "cy", "x", "y"]:
                                    val = el.get(coord_name)
                                    if val is not None:
                                        if not isinstance(val, (int, float)) or val < 0.0 or val > 1.0:
                                            print(f"  [WARNING] Element coordinate '{coord_name}'={val} is out of bounds [0.0, 1.0] in example '{eid}'.")

            # Exercises
            exercises = module.get("exercises", [])
            if not isinstance(exercises, list):
                print(f"  [ERROR] Module '{module_id}' 'exercises' must be a list.")
                has_errors = True
            else:
                for ex in exercises:
                    exid = ex.get("id")
                    if not exid:
                        print(f"  [ERROR] Exercise is missing 'id' in module '{module_id}'.")
                        has_errors = True
                    else:
                        if exid in all_step_ids:
                            print(f"  [ERROR] Duplicate step ID: '{exid}'")
                            has_errors = True
                        all_step_ids.add(exid)
                    if not ex.get("instruction"):
                        print(f"  [ERROR] Exercise '{exid}' is missing 'instruction'.")
                        has_errors = True
                    checklist = ex.get("checklist")
                    if not isinstance(checklist, list) or len(checklist) == 0:
                        print(f"  [ERROR] Exercise '{exid}' 'checklist' must be a non-empty list.")
                        has_errors = True

            # Quizzes
            quizzes = module.get("quizzes", [])
            if not isinstance(quizzes, list):
                print(f"  [ERROR] Module '{module_id}' 'quizzes' must be a list.")
                has_errors = True
            else:
                for q in quizzes:
                    qid = q.get("id")
                    if not qid:
                        print(f"  [ERROR] Quiz is missing 'id' in module '{module_id}'.")
                        has_errors = True
                    else:
                        if qid in all_step_ids:
                            print(f"  [ERROR] Duplicate step ID: '{qid}'")
                            has_errors = True
                        all_step_ids.add(qid)
                    if not q.get("question"):
                        print(f"  [ERROR] Quiz '{qid}' is missing 'question'.")
                        has_errors = True
                    options = q.get("options", [])
                    if not isinstance(options, list) or len(options) < 2:
                        print(f"  [ERROR] Quiz '{qid}' 'options' must be a list with at least 2 choices.")
                        has_errors = True
                    correct = q.get("correctIndex")
                    if not isinstance(correct, int) or correct < 0 or correct >= len(options):
                        print(f"  [ERROR] Quiz '{qid}' 'correctIndex'={correct} is out of bounds for options length {len(options)}.")
                        has_errors = True
                    if not q.get("explanation"):
                        print(f"  [ERROR] Quiz '{qid}' is missing 'explanation'.")
                        has_errors = True

            # Challenges
            challenges = module.get("challenges", [])
            if not isinstance(challenges, list):
                print(f"  [ERROR] Module '{module_id}' 'challenges' must be a list.")
                has_errors = True
            else:
                for ch in challenges:
                    chid = ch.get("id")
                    if not chid:
                        print(f"  [ERROR] Challenge is missing 'id' in module '{module_id}'.")
                        has_errors = True
                    else:
                        if chid in all_step_ids:
                            print(f"  [ERROR] Duplicate step ID: '{chid}'")
                            has_errors = True
                        all_step_ids.add(chid)
                    if not ch.get("title"):
                        print(f"  [ERROR] Challenge '{chid}' is missing 'title'.")
                        has_errors = True
                    if not ch.get("description"):
                        print(f"  [ERROR] Challenge '{chid}' is missing 'description'.")
                        has_errors = True

    if has_errors:
        print("\n[FAIL] Content validation failed. Please check errors above.")
        return False
    else:
        print("\n[SUCCESS] All course files are compliant with schemas and constraints!")
        return True

if __name__ == "__main__":
    success = validate_courses()
    sys.exit(0 if success else 1)
