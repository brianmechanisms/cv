## Creating A Data-driven Jekyll Rendered CV

The goal of this small project is to ease the burden of maintaining a CV by separating the content from the output by treating entries as data without having to real `R` so as to use the existing packages of `R` such as [datadrivencv](http://nickstrayer.me/datadrivencv/) which accomplish the same goals. Further, CVs for a whole team (organization) can be created and hosted using The ode provided here.

## Motivation

Updating a CV, or even writing one from stratch is not easy. A lot of decisions have to be made regarding the layout. And it seems that almost everytime an edit is made in the content, the layout has to be changed as well. Also without a proper word document, the layout just gets messed up whenever the content is editted.

Anytime I would go to add something to my CV I ended up wanting to change the format a tiny bit. This usually meant the entire word document completely falling apart and needing to have each entry copied and pasted into a new version. To help solve this problem, a number of packages have been developed. But most of them use `R`. Again it is not reasonable to learn `R` for the single purpose of writing a CV. So we have adopted to use a spreadsheet to store each entry in the CV and render the CV using jekyll (html+css) and produce a pdf version of the CV from the rendered html CV.

This project uses:
1. Googlesheets
2. bash
3. Jekyll
4. Github pages

## The google Spreadsheet
A tempate of the google sheet is available [here](https://docs.google.com/spreadsheets/d/15gWBr8MMB1omF4vLet04_iasccyYeAFNuH8IiFVYm7M/edit#gid=1730172225). You can make a copy of it. Check the permissions to make sure that the document can be accessed (read) by anyone with the link.

The spreadsheet has to ids: the `document id` and the `sheet id`. Such as in: `https://docs.google.com/spreadsheets/d/<document_id>/export?format=csv&gid=<sheet_id>`. You will need to get both the sheet document Id and sheet Id for all the sheets.

## The CV Data Repo
### Spreadsheet data
Now set Up a CV Data Repo, a template of which is available [here](https://github.com/Surgbc/cv_data/tree/master). Only public repos are supported at the moment.

In this repo you will need to set the ids of the google sheet(s) where you CV data is located in cvs format. This is done in `datasheets.txt`

```
document_1_Id, sheetId
document_2_Id, sheetId
15gWBr8MMB1omF4vLet04_iasccyYeAFNuH8IiFVYm7M,917338460
```

Example:

```
15gWBr8MMB1omF4vLet04_iasccyYeAFNuH8IiFVYm7M,917338460
15gWBr8MMB1omF4vLet04_iasccyYeAFNuH8IiFVYm7M,1381329386
15gWBr8MMB1omF4vLet04_iasccyYeAFNuH8IiFVYm7M,340636497
15gWBr8MMB1omF4vLet04_iasccyYeAFNuH8IiFVYm7M,1730172225
```

All the sheets can be in one document or in different documents.

### Photo Data
This part is optional.
Add your photo into the root of the repo. Edit the `assets.txt` file. Change the section after `photo,` to the name of the file you have uploaded. It is recommended that you use a name without spaces.

## The rendering Repo
A template of the rendering repo is available [here](check). Edit `cvDatarepos.md`. Include line be line the repos of all the CVs you want to render and host in the format: 

```
organization/repo # comment
```

```
Surgbc/cv_data # Brian
```


## Explaining the Code
### Add empty line to the end of file

Add an empty line to the end of the file if it does not already have one:

```bash
[[ $(tail -c1 cvDataRepos.md) && ! $(echo) ]] && echo >> cvDataRepos.md
```

Here's how this command works:

- `tail -c1 cvDataRepos.md`: This command outputs the last byte of the file, which should be a newline character if an empty line exists.
- `[[ $(tail -c1 cvDataRepos.md) && ! $(echo) ]]`: This command uses Bash's [[ command to check if the output of `tail -c1 cvDataRepos.md` is non-empty (i.e., there is no newline character at the end of the file) and if the output of echo (which just outputs an empty line) is empty. This condition will be true if an empty line does not exist at the end of the file.
- `&& echo >> cvDataRepos.md`: This command appends an empty line to the file using the >> operator if the previous condition is true (i.e., an empty line does not exist at the end of the file).

### Create repo urls from repo data and clone repos
```bash
mkdir -p cvData
while read line; do link="https://github.com/${line%%#*}"; link=$(echo $link| sed 's/[[:space:]]*$//'); dir=$(echo "$link" | sed 's/\//__/g');link=$(echo "$link.git"); cd cvData && rm -rf $dir && git clone $link $dir; cd ..; done < cvDataRepos.md 
```
This code:
- Removes trailing the comments from lines beginning with # and adds the leading part of the url: `link="https://github.com/${line%%#*}"` 
- Remove the trailing spaces from the result: `link=$(echo $link| sed 's/[[:space:]]*$//')`
- Generates a directory name from the url: `dir=$(echo "$link" | sed 's/\//__/g')`
- Add the trailing part of the url: `link=$(echo "$link.git")`
- clone the repo in `cvData` directory

### Downloading the spreadsheets in csv format


```bash

for dir in ./cvData/*; do
    if [ -d "$dir" ]; then
        if [ -e "$dir/datasheets.txt" ]; then
            cat  "$dir/datasheets.txt"
            while IFS=, read -r var1 var2; do
                echo "Variable 1: $var1"
                echo "Variable 2: $var2"
            done < "$dir/datasheets.txt"
        fi
    fi
done
```

- Create page for each team member with their name. Reject if downloaded data has no name.
- Create asset dir for each team member.






This


## Downloading content
```bash
wget --output-file="logs.csv" "https://docs.google.com/spreadsheets/d/15gWBr8MMB1omF4vLet04_iasccyYeAFNuH8IiFVYm7M/export?format=csv&gid=917338460" -O "downloaded_content.csv"
```

Import settings from a different repo, so that we can have cvs for several people here.


1381329386
340636497
1730172225


Save document Ids, then delete them download them


Programming Skills should go to the site....

