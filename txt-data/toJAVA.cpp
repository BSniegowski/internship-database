#include <iostream>

using namespace std;

int main(){
    string super = "{";
    int many = 500;
    for(int i=0;i<many;i++) {
        string line;
        getline(cin,line);
        if(line == "dosc") {
            break;
        }
        if(line==""){
            continue;
        }
        if(i == many-1) {
            super.append("\"").append(line).append("\"");
        }
        else {
            super.append("\"").append(line).append("\"").append(", ");
        }
        
    }
    super.append("}");
    cout << super;
}