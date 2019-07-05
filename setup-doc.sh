current_dir="${PWD##*/}"
sed -i '' "s/XXXXX/$current_dir/g" README.md
