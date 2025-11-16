-- worksheet_example.py
-- Simplified example of the Python logic behind my personalized worksheet generator.
-- Author: Kailey Freedman-Setaro

import random

def generate_multiplication_worksheet(student_name, num_questions):

    problems = []

    for i in range(num_questions):
        a = random.randint(10, 99)
        b = random.randint(2, 9)
        problem_text = str(a) + " x " + str(b) + " = ____"
        answer = a * b

        problems.append({
            "question": problem_text,
            "answer": answer
        })

    worksheet = {
        "title": "Multiplication Practice for " + student_name,
        "problems": problems
    }

    return worksheet


# Example
worksheet = generate_multiplication_worksheet("Ava", 5)
print(worksheet)
