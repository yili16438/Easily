import os

def findmatch(file_name, ext, excludes):
    for exclude in excludes:
        if file_name.find(exclude) != -1:
            return False
    return file_name.endswith(ext)

def list_file(dir_name, ext, excludes):
    result = []
    for root, dirs, files in os.walk(dir_name):
        result.extend(os.path.join(root, file_name) for file_name in files if findmatch(file_name, ext, excludes))
    return result

def list_class(root, root_sep, ext, excludes):
    return (format_name(root_sep, file_name, ext) for file_name in list_file(root, ext, excludes))

def format_name(root_sep, file_name, ext):
    return file_name.replace(ext, "").replace(root_sep, "").replace("\\", ".")

def export_file(root_list, ext, excludes, out_file):
    with open(out_file, "w") as f:
        f.write("CLASSES=")
        for root in root_list:
            f.writelines(class_name + " " for class_name in list_class(root, root + "\\", ext, excludes))

def main():
    root_list = [os.getcwd()+"\\..\\src"]
    ext = ".as"
    excludes = ["Test", "test", "b2Utils", "SkillConfig", "Easily.as"]
    out_file = "class.properties"
    export_file(root_list, ext, excludes, out_file)

if __name__ == "__main__":
    main()