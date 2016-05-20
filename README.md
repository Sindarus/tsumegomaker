# tsumegomaker

With this project, we'll be trying to create a advanced copycat of "goproblems.com", using ruby on rails.

### How to test the website
* pull the code
* run bundle exec
* create a pgsql user called "rubypg" that has password "rubypg" and that can create databases
* run rake db:create db:migrate db:seed
* run the server and it should work
* to test the go game-engine, it is recommended that you play the problem #2 : the winning move is in the middle, anywhere else is wrong.

### Avancement au 20/05/2016
* Il est possible d'acceder a la liste des problèmes disponible en cliquant sur "jouer"
* Il est possible de résoudre un problème en cliquant sur le bouton "jouer" a coté du problème en question.
* lorsque le problème est réussi ou raté, un message apparait a droite.
* Il est possible de créer un compte et de se connecter : les problèmes réussis ou ratés sont sauvegardés, pour afficher un indicateur dans la liste des problèmes.
* Nous avons commencé a implémenter la possibilité d'ajouter des problèmes au site, mais cette fonctionnalité n'est pas terminée. Pour l'instant, sur la page "déposer un problème", on peut créer un problème en local (en javascript), mais ce dernier n'est pas envoyé au serveur.

### Things we shall do:
* a web interface that allows one to play on a go board.
* the actual go game engine
* an interface to submit problems
* an engine to solve and provide every variation possible, as well as the evaluation of every possible outcome. We'll be using the minimax algorithm.

### We'll probably be using:
* ruby and ruby on rails, obviously
* [HTML5 new stuff](https://commons.wikimedia.org/wiki/File:HTML5_APIs_and_related_technologies_taxonomy_and_status.svg?uselang=fr) because it looks cool.
* [twitter bootstrap](https://getbootstrap.com/) or [materialize](http://materializecss.com/), because we like pretty stuff but we do not want to spend too much time on aesthetics.
* [javascript](https://openclassrooms.com/courses/dynamisez-vos-sites-web-avec-javascript) to make the web interface, inside a [canvas](http://www.w3schools.com/HTML/html5_canvas.asp) html tag.
* either [Ajax](https://openclassrooms.com/courses/dynamisez-vos-sites-web-avec-javascript/l-ajax-qu-est-ce-que-c-est) or [websockets](https://fr.wikipedia.org/wiki/WebSocket) to make the client and the server communicate their moves smoothly.
* a [sgf](https://en.wikipedia.org/wiki/Smart_Game_Format) file format [parser](https://rubygems.org/search?utf8=%E2%9C%93&query=sgf), to see what JS data structure people used to represent a game tree. And, eventually, to make sgf import possible. (specifications [here](http://www.red-bean.com/sgf/))
