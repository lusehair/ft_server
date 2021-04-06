**Ft_Server** 

> *"Laissez-lui au moins un pourboire !"*

Après s'être battu avec le C, il est temps de se quitter, le temps d'un petit projet qui nous fait découvrir un autre domaine de la programmation. Le web. Ici, il n'est pas question de faire un simple serveur web (trop simple pour un stud de 42) 
*"Tu va le faire avec un truc que t'as pas encore vu ! Docker !"*
Cancel changes
Donc, le but étant se faire un script Docker (et plus) pour automatiser le déploiement d'un serveur nginx avec wordpress dessus. Pour que cela fonctionne correctement, il faut logiquement Docker sur sa machine et écrire les commandes suivantes : 

Pour construire l'image Docker : 

    docker build -t ft_server .

Et pour lancer l'image : 

    docker run -it -p 82:82 -p 443:443 ft_server

à noter, que j'ai volontairement attribuer le port 82, car le 80 était déjà utilisé par ma machine. Pour le remettre sur le 80 il faut modifier les fichiers suivants : 

Dockerfile : 

  ~~`EXPOSE 82 443`~~
  en 

      EXPOSE 80 443

Dans le srcs/nginx-conf 

    server {
    
    listen 82;
    
    listen [::]:82;
    
    server_name lusehair;
    
    return 301 https://$server_name$request_uri;
    
    }
en : 

    server {
    
    listen 80;
    
    listen [::]:80;
    
    server_name lusehair;
    
    return 301 https://$server_name$request_uri;
    
    }

