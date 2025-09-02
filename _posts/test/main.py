import os
import sys
import datetime

# --- 配置区 ---
# 安全开关：True = 只打印计划，不执行操作 | False = 实际执行重命名操作
DRY_RUN = False

# 新配置：起始日期，格式为 "YYYY-MM-DD"
# 脚本将从这个日期开始，每天向后递增。
START_DATE_STR = "2023-03-17"


# --- 配置区结束 ---

def batch_rename_markdown_files():
    """
    对当前目录下的所有.md文件进行批量重命名，
    从指定的起始日期开始，添加一个按天递增的日期前缀 (YYYY-MM-DD-)。
    """
    try:
        # 解析起始日期
        try:
            start_date = datetime.datetime.strptime(START_DATE_STR, "%Y-%m-%d").date()
        except ValueError:
            print(f"[错误] 起始日期格式无效: '{START_DATE_STR}'。请使用 YYYY-MM-DD 格式。", file=sys.stderr)
            return

        # 获取当前脚本所在的目录
        current_directory = os.getcwd()
        print(f"[*] 正在扫描目录: {current_directory}")

        # 1. 找出所有.md文件
        md_files = [f for f in os.listdir(current_directory) if f.endswith('.md')]

        if not md_files:
            print("[!] 在当前目录中没有找到任何.md文件。")
            return

        # 2. 按文件名进行排序，确保重命名顺序一致
        md_files.sort()
        print(f"[*] 找到 {len(md_files)} 个.md文件，准备重命名...")
        print(f"[*] 日期将从 {START_DATE_STR} 开始递增。")

        if DRY_RUN:
            print("\n" + "=" * 20)
            print("  演练模式 (DRY RUN)  ")
            print("  文件不会被真正重命名  ")
            print("=" * 20 + "\n")
        else:
            print("\n" + "=" * 20)
            print("  !!! 执行模式 !!!  ")
            print("  文件将被实际重命名  ")
            print("=" * 20 + "\n")
            # 在执行模式前给予用户确认机会
            confirm = input("您确定要继续吗？ (输入 'y' 或 'yes' 继续): ").lower()
            if confirm not in ['y', 'yes']:
                print("[!] 操作已取消。")
                return

        # 3. 遍历文件并重命名
        for i, filename in enumerate(md_files):
            # 计算当前文件的日期
            current_date = start_date + datetime.timedelta(days=i)

            # 格式化日期前缀，例如：2023-05-01-
            prefix = current_date.strftime('%Y-%m-%d-')

            # 构造新的文件名
            new_filename = f"{prefix}{filename}"

            # 获取完整的文件路径
            old_filepath = os.path.join(current_directory, filename)
            new_filepath = os.path.join(current_directory, new_filename)

            print(f"  - {filename}  ->  {new_filename}")

            # 4. 如果不是演练模式，则执行重命名
            if not DRY_RUN:
                try:
                    os.rename(old_filepath, new_filepath)
                except OSError as e:
                    print(f"  [错误] 重命名文件 '{filename}' 失败: {e}", file=sys.stderr)

        print("\n[*] 操作完成！")

    except Exception as e:
        print(f"\n[致命错误] 脚本执行失败: {e}", file=sys.stderr)


if __name__ == "__main__":
    batch_rename_markdown_files()

