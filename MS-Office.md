
# Microsoft Office, O365, and co

## Excel

```vb
=CONCAT("INSERT INTO boite (code, libelle, photo) VALUES ('";A2;"','";SUBSTITUE(SUBSTITUE(B2; "’"; "'"); "'"; "''");"','";C2;"');")