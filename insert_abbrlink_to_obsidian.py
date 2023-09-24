import os

directory_A = "./source/_posts"  # 目录A的路径
directory_B = "../notes-obsidian/BLOG"  # 目录B的路径

for root, dirs, files in os.walk(directory_A):
    for file_name in files:
        file_path_A = os.path.join(root, file_name)  # 目录A中的文件路径
        file_path_B = os.path.join(directory_B, file_name)  # 目录B中的文件路径

        if os.path.exists(file_path_B):
            with open(file_path_A, "r", encoding="utf-8") as file_A:
                lines_A = file_A.readlines()

            matching_lines = [
                line for line in lines_A if line.startswith("abbrlink")]

            with open(file_path_B, "r", encoding="utf-8") as file_B:
                lines_B = file_B.readlines()

            existing_abbrlinks = [
                line for line in lines_B if line.startswith("abbrlink")]

            # 如果目录B中的同名文件已经存在相同的以 'abbrlink' 开头的行，则跳过该文件
            if any(line in existing_abbrlinks for line in matching_lines):
                continue

            lines_B.insert(2, "\n".join(matching_lines))

            with open(file_path_B, "w", encoding="utf-8") as file_B:
                file_B.writelines(lines_B)
