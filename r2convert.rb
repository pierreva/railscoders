#Upgrading to Rails 2.0
#Posted by Bryan on February 16, 2008
#Here’s a couple one-liner scripts to help convert your Rails app to 2.0. 
#These scripts are by no means perfect, but should help if you have a lot 
# of files with “start_form_tag”, “end_form_tag”, or “:post => true”. Back your files up first, of course.

find . |grep -i "\.erb$" | xargs ruby -p -i -e "gsub(/<%=.*start_form_tag(.*)%>/i, '<% form_tag \1 do -%>')"
find . |grep -i "\.erb$" | xargs ruby -p -i -e "gsub(/<%.*end_form_tag.*%>/i, '<% end #form_tag-%>')"
find . |grep -i "\.erb$" | xargs ruby -p -i -e 'gsub(/:post\s=>\strue/i, ":method\s=>\s:post")'
#Replace “erb” with “rtml” if you haven’t converted your views to .erb yet.