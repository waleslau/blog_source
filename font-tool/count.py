import glob

characters = []  # 存放不同字的总数
rate = {}  # 存放每个字出现的频率
dir_to_exclude = ['B', 'C']
all_text = ''

files = glob.glob('../source/*/*.md', recursive=True)
files_paths = [_ for _ in files if _.split("\\")[0] not in dir_to_exclude]
# print(f'List of file names with path: {files_paths}')
# files_names = [_.split("\\")[-1] for _ in files if _.split("\\")[0] not in dir_to_exclude]
# print(f'List of file names: {files_names}')

for file in files_paths:
    fr = open(file, 'r', encoding='UTF-8')
    # 读取文件所有行
    content = fr.readlines()
    # 依次迭代所有行
    for line in content:
        # 去除空格
        line = line.strip()
        line = line.replace(" ", "")
        # 如果是空行，则跳过
        if len(line) == 0:
            continue
        all_text += line

text1 = "热心市民L先生のBLOG首页归档分类标签关于友链其他HOMELinux常用软件列表我能吞下玻璃而不伤身体AaBbCcDdEeFfGgHhIiGgKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789-这是段落这是代码块 <--> This is code <--<"
all_text += text1

# 统计每一字出现的个数
for i in all_text:
    # 如果字符第一次出现 加入到字符数组中
    if i not in characters:
        characters.append(i)
    # 如果是字符第一次出现 加入到字典中
    if i not in rate:
        rate[i] = 0
    # 出现次数加一
    rate[i] += 1

# 对字典进行倒数排序 从高到低 其中e表示dict.items()中的一个元素，
# e[1]则表示按 值排序如果把e[1]改成e[0]，那么则是按键排序，
# reverse=False可以省略，默认为升序排列
rate = sorted(rate.items(), key=lambda e: e[1], reverse=False)

print(f'共{len(all_text)}个字')
print(f'其中有{len(characters)}个不同的字')
print()
# for i in rate:
#     print("[", i[0], "] 共出现 ",  i[1], "次")

characters.sort()
print(''.join(characters))

text = ''.join(characters)
text_file = open("characters_count.txt", "w")
text_file.write(text)
text_file.close
