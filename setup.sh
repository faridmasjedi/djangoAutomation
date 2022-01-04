#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


echo "---------------------------------"
echo "1. To make a new django project"
echo "2. Make a new app inside that project"
echo "3. make a new admin"
echo "4. make a new model inside an app"
echo "5. make a new view"
echo "6. run the server"
echo -e "\n\n"
read -rp "Which command do you want to run? " comNum

if [[ $comNum = 1 ]];then
    read -rp "What is your project name? " pName
    django-admin startproject $pName $(realpath .)
    addUrlString="from django.urls import include\n"
    echo -e $addUrlString >> "./$pName/urls.py"
elif [[ $comNum = 2 ]];then
    read -rp "What is your app name? " appName
    read -rp "What was your project name? " prName
    python3 manage.py startapp $appName
    echo ""
    echo "${red} add the following command into the ./$prName/settings.py"

    echo "${green} add the following into INSTALLED_APPS array: '$appName.apps.<"$appName"-capitalized>Config'"
    echo "${reset}"
    touch "./$appName/urls.py"
    urlString="from django.urls import path\nfrom . import views\nurlpatterns=[\n\tpath('hello${appName}', views.hello${appName})\n]"
    echo -e $urlString >> "./$appName/urls.py"
    viewString="from django.http import HttpResponse\n\ndef hello${appName}(req):\n\treturn HttpResponse('Hello World!!!')\n"
    echo -e $viewString >> "./$appName/views.py"
    addUrl="\n\nurlpatterns.append(path('${appName}/',include('${appName}.urls')))"
    echo -e $addUrl >> "./$prName/urls.py"
    mkdir "./$appName/templates"
elif [[ $comNum = 3 ]];then
    python3 manage.py makemigrations
    echo -e "-----\n"
    python3 manage.py migrate
    echo -e "-----\n"
    python3 manage.py createsuperuser
    echo -e "-----\n"
    open http://127.0.0.1:8000/admin
    python3 manage.py runserver
elif [[ $comNum = 4 ]];then
    read -rp "What is your app name? " appName
    read -rp "What is your model name? (capitalized) " modelName 
    str="\n\nclass $modelName(models.Model):"
    echo -e $str >> "./$appName/models.py"
    flag=true
    while [[ $flag = true ]]; do
        read -rp "What is your column name? " colName
        read -rp "What is the type of $colName? " colType
        t=''
        if [[ $colType = string ]];then
            read -rp "what is the max length of that? " mLen
            t="\t$colName = models.CharField(max_length = $mLen)"
        elif [[ $colType = float ]];then
            t="\t$colName = models.FloatField()"
        elif [[ $colType = integer ]];then
            t="\t$colName = models.IntegerField()"
        fi
        echo -e $t >> "./$appName/models.py"
        echo ""
        read -rp "Do you want to another column (y/n)? " addCol
        if [[ $addCol = n || $addCol = N ]];then
            flag=false
        fi
    done
    python3 manage.py makemigrations
    echo -e "---\n"
    python3 manage.py migrate
    echo -e "---\n"
    read -rp "Do you want to have this model into admin section(y/n)? " adminShow
    if [[ $adminShow = y || $adminShow = Y ]];then
        flag=true
        read -rp "Do you want to have a list display on admin section(y/n)? " listFlag
        if [[ $listFlag = n || $listFlag = N ]];then
            flag=false
        fi
        str="\n\nfrom .models import $modelName\n\nclass "$modelName"Admin(admin.ModelAdmin):\n\tlist_display = ("
        echo -e $str >> "./$appName/admin.py"
        cols=''
        while [[ $flag = true ]]; do            
            read -rp "Input the name of the column to be displayed: " colDisp
            read -rp "Do you want to add another one(y/n)? " colAddDisp
            if [[ $colAddDisp = n || $colAddDisp = N ]];then
                flag=false
                echo "$cols""'$colDisp')" >> "./$appName/admin.py"
            else
                cols="'$colDisp',$cols"
            fi
        done
        str="\n\nadmin.site.register($modelName,"$modelName"Admin)"
        echo -e $str >> "./$appName/admin.py"
    fi
    viewString="from .models import ${modelName}"
    echo -e $viewString >> "./${appName}/views.py"
elif [[ $comNum = 5 ]];then
    read -rp "What is the name of the app? " appName
    read -rp "Have you made a model in ${appName} app (y/n)? " modelExisted

    if [[ $modelExisted = n || $modelExisted = N ]];then
        exit 1
    fi
    read -rp "What is the name of the module? " mName
    read -rp "Name of one of the columns in this module?" cName
    read -rp "What is the name of the template? " tName
    read -rp "What is the url for that? " url
    urlString="\nurlpatterns.append(path('${url}', views.${tName}))"
    echo -e $urlString >> "./${appName}/urls.py"
    viewString="\n\ndef ${tName}(req):\n\tall = ${mName}.objects.all()\n\treturn render(req, '${tName}.html',{'all' : all})"
    echo -e $viewString >> "./${appName}/views.py"
    touch "./${appName}/templates/${tName}.html"
    htmlString="<h1>${appName}s</h1>\n{% for i in all %}\n\t<p>{{ i.${cName} }} </p>\n{% endfor %}"
    echo -e $htmlString >> "./${appName}/templates/${tName}.html"
    open http://127.0.0.1:8000/${appName}/${url}
    python3 manage.py runserver
elif [[ $comNum = 6 ]];then
    open http://127.0.0.1:8000/
    python3 manage.py runserver
fi