" Title:        Capibara Plugin
" Description:  A plugin to interface with Capibara documentation.
" Last Change:  20 February 2023
" Maintainer:   Justin Woodring <https://github.com/JustinWoodring>

python3 << EOF
# Imports Python modules to be used by the plugin.
import vim
import re
import json, requests
import os

request_headers = { "accept": "application/json" }
request_base_url = "https://capibara.tools/capibara.json"
definition_file_location = os.path.expanduser("~/.vim-capibara-definitions.json")

def sponsor_plugin():
    print("""
                    ***********         
                  ,**************.      
             .*******************       
         ,******************,.          
        ********************            
       ********************             
       ********************             

                Capibara                    
 
----------------------------------------
   Vim integration by Justin Woodring   
 
        Sponsor this plugin at:         
   github.com/sponsors/JustinWoodring   
 
      Or contribute to Capibara at:     
            capibara.tools              
----------------------------------------
""")

def load_definitions():

    if (os.path.isfile(definition_file_location)):
        with open(definition_file_location, 'r') as reader:
            return reader.read()

    download_definitions()

    if (os.path.isfile(definition_file_location)):
        with open(definition_file_location, 'r') as reader:
            return reader.read()


def download_definitions():
    response = requests.get(request_base_url, headers=request_headers)

    if (response.status_code != 200):
        print(response.status_code + ": " + response.reason)
        return

    with open(definition_file_location, 'w') as writer:
        writer.write(response.text)

    print("Capibara definitions downloaded successfully.")


# Fetches available definitions for a given word.
def get_capibara_definitions(word_to_lookup):
    definition_json = json.loads(load_definitions())

    for definition_item in definition_json["functions"]:
        if (definition_item["name"]==word_to_lookup):
            print("\n \n")
            print(definition_item["header"]["name"])
            print("function", definition_item["name"]+"(", end="")
            for parameter in definition_item["parameters"]:
                print("`"+parameter["type"]+"` "+parameter["name"]+",", end="")
            print(")")
            print("---")
            print("summary:",definition_item["summary"])
            print("---")
            print("returns:","`"+definition_item["returns"]["type"]+"`","-",definition_item["returns"]["description"])
            print("---")
            print("parameters:")
            for parameter in definition_item["parameters"]:
                print("  - ",parameter["name"]+":","`"+parameter["type"]+"`","-",parameter["description"])
            print("---")
            print("environments:",definition_item["os_affinity"])
            print("---")
            print("description:")
            print(re.sub(r"([^\n])\n([^\n])",r"\1 \2",re.sub(r"\n-",r"\n\n  *",definition_item["description"])).replace("\n\n","\n \n"))
            print("---")
            print("\n\n\n")

    for definition_item in definition_json["enums"]:
        if (definition_item["name"]==word_to_lookup):
            print("\n \n")
            print(definition_item["header"]["name"])
            print("enum", definition_item["name"])
            print("---")
            print("summary:",definition_item["summary"])
            print("---")
            print("variants:")
            for variant in definition_item["variants"]:
                print("  - ",variant["name"]+":", variant["description"])
            print("---")
            print("environments:",definition_item["os_affinity"])
            print("---")
            print("description:")
            print(re.sub(r"([^\n])\n([^\n])",r"\1 \2",re.sub(r"\n-",r"\n\n  *",definition_item["description"])).replace("\n\n","\n \n"))
            print("---")
            print("\n\n\n")

    for definition_item in definition_json["structs"]:
        if (definition_item["name"]==word_to_lookup):
            print("\n \n")
            print(definition_item["header"]["name"])
            print("struct", definition_item["name"])
            print("---")
            print("summary:",definition_item["summary"])
            print("---")
            print("fields:")
            for field in definition_item["fields"]:
                print("  - ",field["name"]+":","`"+field["type"]+"`","-",field["description"])
            print("---")
            print("environments:",definition_item["os_affinity"])
            print("---")
            print("description:")
            print(re.sub(r"([^\n])\n([^\n])",r"\1 \2",re.sub(r"\n-",r"\n\n  *",definition_item["description"])).replace("\n\n","\n \n"))
            print("---")
            print("\n\n\n")

    for definition_item in definition_json["macros"]:
        if (definition_item["name"]==word_to_lookup):
            print("\n \n")
            print(definition_item["header"]["name"])
            if ("function" in definition_item["kind"]):
                print("macro (function-like)", definition_item["name"]+"(", end="")
                for parameter in definition_item["kind"]["function"]["parameters"]:
                    print(parameter["name"]+",", end="")
                print(")")
            else: 
                print("macro (object-like)", definition_item["name"])
            print("---")
            print("summary:",definition_item["summary"])
            if ("function" in definition_item["kind"]):
                print("---")
                print("returns:","`"+definition_item["kind"]["function"]["returns"]["type"]+"`","-",definition_item["kind"]["function"]["returns"]["description"])
                print("---")
                print("parameters:")
                for parameter in definition_item["kind"]["function"]["parameters"]:
                    print("  - ",parameter["name"]+":","-",parameter["description"])
            print("---")
            print("environments:",definition_item["os_affinity"])
            print("---")
            print("description:")
            print(re.sub(r"([^\n])\n([^\n])",r"\1 \2",re.sub(r"\n-",r"\n\n  *",definition_item["description"])).replace("\n\n","\n \n"))
            print("---")
            print("\n\n\n")

    for definition_item in definition_json["typedefs"]:
        if (definition_item["name"]==word_to_lookup):
            print("\n \n")
            print(definition_item["header"]["name"])
            print("typedef", definition_item["name"], definition_item["type"])
            print("---")
            print("summary:",definition_item["summary"])
            print("---")
            print("type:",definition_item["type"])
            print("---")
            print("linked type definition:")
            if ("enum" in definition_item["associated_ref"]):
                print("###")
                print(definition_item["associated_ref"]["enum"]["header"]["name"])
                print("enum", definition_item["associated_ref"]["enum"]["name"])
                print("---")
                print("summary:",definition_item["associated_ref"]["enum"]["summary"])
                print("---")
                print("variants:")
                for variant in definition_item["associated_ref"]["enum"]["variants"]:
                    print("  - ",variant["name"]+":", variant["description"])
                print("---")
                print("environments:",definition_item["associated_ref"]["enum"]["os_affinity"])
                print("---")
                print("description:")
                print(re.sub(r"([^\n])\n([^\n])",r"\1 \2",re.sub(r"\n-",r"\n\n  *",definition_item["associated_ref"]["enum"]["description"])).replace("\n\n","\n \n"))
                print("---")
                print("###")
            elif("struct" in definition_item["associated_ref"]):
                print("###")
                print(definition_item["associated_ref"]["struct"]["header"]["name"])
                print("struct", definition_item["associated_ref"]["struct"]["name"])
                print("---")
                print("summary:",definition_item["associated_ref"]["struct"]["summary"])
                print("---")
                print("fields:")
                for field in definition_item["associated_ref"]["struct"]["fields"]:
                    print("  - ",field["name"]+":","`"+field["type"]+"`","-",field["description"])
                print("---")
                print("environments:",definition_item["associated_ref"]["struct"]["os_affinity"])
                print("---")
                print("description:")
                print(re.sub(r"([^\n])\n([^\n])",r"\1 \2",re.sub(r"\n-",r"\n\n  *",definition_item["associated_ref"]["struct"]["description"])).replace("\n\n","\n \n"))
                print("---")
                print("###")
            else:
                print("No linked type definition")
            print("---")
            print("environments:",definition_item["os_affinity"])
            print("---")
            print("description:")
            print(re.sub(r"([^\n])\n([^\n])",r"\1 \2",re.sub(r"\n-",r"\n\n  *",definition_item["description"])).replace("\n\n","\n \n"))
            print("---")
            print("\n\n\n")
EOF

" Calls the Python 3 function.
function! capibara#CapibaraLookUp()
    let cursorWord = expand('<cword>')
    python3 get_capibara_definitions(vim.eval('cursorWord'))
endfunction

" Calls the Python 3 function.
function! capibara#CapibaraRefreshDefinitions()
    python3 download_definitions()
endfunction 

" Calls the Python 3 function.
function! capibara#CapibaraSponsorPlugin()
    python3 sponsor_plugin()
endfunction 