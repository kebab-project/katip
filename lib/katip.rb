require 'katip/version'

module Katip
  require 'katip/railtie' if defined?(Rails)

  @@daktilo = <<-SHELL
# Get tags as an array
TAGS_ARRAY=(`git for-each-ref --sort='*authordate' --format='%(tag)' refs/tags | grep -v '^$'`)

repo_url="../../commit/"

# Set User defined file if exist else use default
if [ -n "$1" ]; then
  OUTPUT=$1
else
  OUTPUT="CHANGELOG.md"
fi

# Calculate the tag count
SIZE=${#TAGS_ARRAY[@]}

echo "\n#### [Current]" > $OUTPUT

# Iterate reversly on tags
for (( i = SIZE - 1; i >= 0 ; i-- ));
do
  CURR_TAG=${TAGS_ARRAY[$i]}
    echo "" >> $OUTPUT
    if [ $PREV_TAG ];then
        echo "#### [$PREV_TAG]" >> $OUTPUT
    fi
    git log --pretty=format:" * [%h]($repo_url%h) %s __(%an)__" $CURR_TAG..$PREV_TAG | grep -v "Merge branch " >> $OUTPUT
    PREV_TAG=$CURR_TAG
done

# Dump change log for first tag
FIRST=$(git tag -l | head -1)
echo "\n#### [$FIRST]" >> $OUTPUT

git log --pretty=format:" * [%h]($repo_url%h) %s __(%an)__" $FIRST | grep -v "Merge branch " >> $OUTPUT
  SHELL

  def self.set(param)
    @@daktilo = param
  end

  def self.get
    @@daktilo
  end

end