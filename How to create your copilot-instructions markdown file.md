# How to create your `copilot-instructions.md` file

Here’s how to create and store a `copilot-instructions.md` file so that GitHub Copilot and Copilot Chat in VS Code can use your custom instructions effectively:

---

## 1. **Creating the `copilot-instructions.md` File**

- Create a new Markdown file named `copilot-instructions.md`.
- This file will contain your custom instructions, guidelines, or prompts for Copilot to follow when generating responses or code[1][7][8].

---

## 2. **Where to Store the File**

- Place the `copilot-instructions.md` file inside a special folder in your repository:
  - At the root level of your project, create a folder called `.github` if it doesn’t already exist[4].
  - Place your `copilot-instructions.md` file inside this `.github` folder, so the path will be:  
    ```
    your-repo/.github/copilot-instructions.md
    ```
- This location ensures that Copilot in VS Code, GitHub, and other supported environments can automatically detect and use your instructions[1][4][6][7][8].

---

## 3. **How Copilot Uses This File**

- When you have a `copilot-instructions.md` file in the `.github` folder of your repository, Copilot Chat and related features will automatically incorporate the contents of this file as context for its responses[1][7].
- This enables Copilot to tailor its suggestions and answers according to your specific guidelines, coding practices, or project requirements[2][5][8].

---

## 4. **Additional Notes**

- You can update or expand the instructions in this file at any time. Changes will be picked up by Copilot the next time it is used in your repository.
- You can also use additional `.instructions.md` files for more granular control if needed (e.g., per subdirectory or per specific feature)[8].

---

### **Summary Table**

| Step | Action                                    | Path Example                        |
|------|-------------------------------------------|-------------------------------------|
| 1    | Create `.github` folder (if missing)      | `/your-repo/.github/`               |
| 2    | Add `copilot-instructions.md`             | `/your-repo/.github/copilot-instructions.md` |