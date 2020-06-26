#./star codesign ipa包名 framework名称
#!/bin/bash
command="codesign"
input="$1"
input2="$2"
input3="$3"
echo '开始执行'
if [ $command == $input ]
then
echo '进来了'

unzip $input2.ipa
security cms -D -i embedded.mobileprovision > embedded.plist
/usr/libexec/PlistBuddy -x -c 'Print:Entitlements' embedded.plist > entitlements.plist

if [ -d "Payload/$input2.app/Frameworks/" ];then
echo "文件夹存在"
else
mkdir Payload/$input2.app/Frameworks/
echo "文件夹不存在"
fi
cp -r $input3.framework Payload/$input2.app/Frameworks/

cd Payload/$input2.app
yololib $input2 Frameworks/$input3.framework/$input3
cd ..
cd ..

rm -rf Payload/$input2.app/_CodeSignature/

cp embedded.mobileprovision Payload/$input2.app/
cp embedded.mobileprovision Payload/$input2.app/PlugIns/NotificationServiceZY.appex/
#
function framework_name(){
for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
        echo $1"/"$file"  这个文件是一个文件夹"
                if [ $file == _CodeSignature ]
                then
                echo "找到了"$1"/"$file"  这个文件夹并删除"
                rm -rf $1"/"$file
                codesign -f -s "iPhone Distribution: Beijing Koboro Health Technology Co., Ltd." --entitlements entitlements.plist $1
                else
                #继续寻找
                framework_name $1"/"$file
                fi
        else
        echo $1"/"$file"  这个文件不是一个文件夹"
        fi
done
}

framework_name ~/Desktop/hanyu/Payload/$input2.app/Frameworks
framework_name ~/Desktop/hanyu/Payload/$input2.app/PlugIns


codesign -f -s "iPhone Distribution: Beijing Koboro Health Technology Co., Ltd." --entitlements entitlements.plist Payload/$input2.app

zip -r new.ipa Payload/
codesign -vv -d Payload/$input2.app
#rm -r Payload

else
echo '错误'
fi

123
456
789
10 11 12
13
