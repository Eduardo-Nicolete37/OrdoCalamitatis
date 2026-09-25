## BCD user

```mermaid
erDiagram

userTabela {
    int ID pk
    username varchar(255) "Unique/Not Null"
    email TEXT "Unique/Not Null/Dominio especifico"
    passwdHash TEXT "Not Null"
    
}
```