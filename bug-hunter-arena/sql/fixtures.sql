-- Insertion des Technologies
INSERT INTO technologies (id, name) VALUES 
(1, 'PHP'), 
(2, 'JavaScript (ReactJS)'), 
(3, 'C++'), 
(4, 'C#'), 
(5, 'Mobile');

-- ==========================================
-- INSERTION DES QUIZZES (PHP - ID 1)
-- ==========================================
INSERT INTO quizzes (id, technology_id, bug_description, code_snippet) VALUES 
(1, 1, 'Le code plante avec une erreur fatale car on essaie d''ajouter un élément à une chaîne.', '$users = "";\n$users[] = "Alice";'),
(2, 1, 'Vulnérabilité critique : ce code est ouvert aux injections SQL.', '$username = $_POST["user"];\n$query = "SELECT * FROM users WHERE username = ''" . $username . "''";'),
(3, 1, 'Erreur "Headers already sent". La redirection ne fonctionne pas.', 'echo "Bienvenue";\nheader("Location: /dashboard.php");'),
(4, 1, 'Le dernier élément du tableau est écrasé lors d''une seconde boucle à cause de la référence.', 'foreach($array as &$val) { $val *= 2; }\nforeach($array as $val) { echo $val; }'),
(5, 1, 'La condition s''exécute même si la variable contient la chaîne "0".', 'if ($val == false) { echo "Faux"; }'),
(6, 1, 'Erreur "Call to a member function on null" si l''utilisateur n''existe pas.', '$user = getUser();\necho $user->getName();'),
(7, 1, 'Les variables de session ne sont pas sauvegardées d''une page à l''autre.', '$_SESSION["user_id"] = 123;\necho "Connecté";'),
(8, 1, 'La variable $count n''est pas modifiée en dehors de la fonction.', '$count = 0;\nfunction increment() { $count++; }\nincrement();'),
(9, 1, 'On tente d''accéder à la propriété d''un objet, mais json_decode a renvoyé un tableau.', '$data = json_decode(''{"name":"Bug"}'', true);\necho $data->name;'),
(10, 1, 'L''utilisateur ne peut pas utiliser "0" comme quantité, le panier le refuse.', 'if (empty($_POST["qty"])) { echo "Quantité invalide"; }'),
(11, 1, 'Erreur "Undefined index" si la clé n''existe pas dans l''URL.', '$page = $_GET["page"];\ninclude($page . ".php");'),
(12, 1, 'La condition ne détecte pas l''erreur si file_get_contents renvoie un string vide.', '$file = file_get_contents("data.txt");\nif ($file == false) { echo "Erreur"; }'),
(13, 1, 'L''exception n''est pas attrapée car on est dans un namespace.', 'namespace App;\ntry { throw new Exception("Erreur"); } catch (Exception $e) {}'),
(14, 1, 'La vérification du mot de passe échoue toujours avec password_hash.', 'if (md5($input) === $db_hash) { echo "OK"; }'),
(15, 1, 'strpos renvoie 0 (qui équivaut à false) si la lettre est au tout début du mot.', 'if (!strpos("Apple", "A")) { echo "Non trouvé"; }'),
(16, 1, 'Avertissement "count(): Parameter must be an array" sous PHP 8.', '$list = null;\necho count($list);'),
(17, 1, 'Les clés numériques du deuxième tableau écrasent celles du premier.', '$arr1 = [1 => "A"];\n$arr2 = [1 => "B"];\n$res = $arr1 + $arr2;'),
(18, 1, 'in_array trouve la chaîne "1" même si on cherche l''entier 1 (comportement non strict).', 'if (in_array("1", [1, 2, 3])) { echo "Trouvé"; }'),
(19, 1, 'La fonction retourne null au lieu d''attendre la fin de l''exécution.', 'function getData() { return\n ["A", "B"]; }'),
(20, 1, 'Faille XSS : les balises HTML s''exécutent dans le navigateur du client.', 'echo "Commentaire : " . $_POST["comment"];');

-- ==========================================
-- INSERTION DES RÉPONSES (PHP - 4 options par quiz)
-- ==========================================
INSERT INTO answers (quiz_id, solution_text, is_correct) VALUES 
-- Quiz 1
(1, 'Remplacer $users = ""; par $users = [];', TRUE), (1, 'Utiliser array_push sans changer l''initialisation', FALSE), (1, 'Remplacer $users[] par $users[0]', FALSE), (1, 'Changer les guillemets en simples quotes', FALSE),
-- Quiz 2
(2, 'Utiliser des requêtes préparées avec PDO ou MySQLi', TRUE), (2, 'Ajouter htmlspecialchars() autour de $_POST', FALSE), (2, 'Utiliser strip_tags() sur la variable', FALSE), (2, 'Échapper les guillemets avec addslashes()', FALSE),
-- Quiz 3
(3, 'Supprimer le echo "Bienvenue"; avant le header()', TRUE), (3, 'Utiliser javascript pour rediriger', FALSE), (3, 'Ajouter un ob_start() après le echo', FALSE), (3, 'Mettre le header() dans une fonction', FALSE),
-- Quiz 4
(4, 'Ajouter unset($val); après la première boucle', TRUE), (4, 'Utiliser une boucle for classique au lieu de foreach', FALSE), (4, 'Changer le nom de la variable dans la 2ème boucle', FALSE), (4, 'Retirer le & dans la première boucle', FALSE),
-- Quiz 5
(5, 'Utiliser la comparaison stricte : if ($val === false)', TRUE), (5, 'Utiliser is_null($val)', FALSE), (5, 'Faire if (!$val)', FALSE), (5, 'Utiliser la fonction empty($val)', FALSE),
-- Quiz 6
(6, 'Vérifier if ($user !== null) avant d''appeler la méthode', TRUE), (6, 'Utiliser $user->getName() ?? ""', FALSE), (6, 'Mettre un @ devant l''appel : @$user->getName()', FALSE), (6, 'Caster $user en objet : (object)$user', FALSE),
-- Quiz 7
(7, 'Appeler session_start(); tout en haut du script', TRUE), (7, 'Utiliser les cookies avec setcookie() à la place', FALSE), (7, 'Passer l''ID dans l''URL via $_GET', FALSE), (7, 'Modifier le php.ini pour activer session.auto_start', FALSE),
-- Quiz 8
(8, 'Ajouter global $count; au début de la fonction', TRUE), (8, 'Passer la variable par valeur : increment($count)', FALSE), (8, 'Déclarer $count comme const', FALSE), (8, 'Utiliser $this->count++', FALSE),
-- Quiz 9
(9, 'Utiliser $data["name"] car json_decode(..., true) renvoie un tableau', TRUE), (9, 'Retirer le paramètre true de json_decode', FALSE), (9, 'Utiliser json_encode() à la place', FALSE), (9, 'Caster le résultat : (object)$data', FALSE),
-- Quiz 10
(10, 'Utiliser isset() ou vérifier if ($_POST["qty"] !== "")', TRUE), (10, 'Faire if ($_POST["qty"] == null)', FALSE), (10, 'Utiliser array_key_exists()', FALSE), (10, 'Changer "qty" en intval($_POST["qty"])', FALSE),
-- Quiz 11
(11, 'Vérifier isset($_GET["page"]) et valider le contenu avant l''include', TRUE), (11, 'Ajouter un @ devant le $_GET pour cacher l''erreur', FALSE), (11, 'Utiliser require_once au lieu de include', FALSE), (11, 'Déclarer $page = "" en haut du fichier', FALSE),
-- Quiz 12
(12, 'Utiliser if ($file === false) avec comparaison stricte', TRUE), (12, 'Utiliser if (!empty($file))', FALSE), (12, 'Faire un try/catch autour de file_get_contents', FALSE), (12, 'Vérifier la taille avec filesize()', FALSE),
-- Quiz 13
(13, 'Utiliser catch (\\Exception $e) pour cibler l''espace global', TRUE), (13, 'Changer Exception en Error', FALSE), (13, 'Supprimer le namespace App;', FALSE), (13, 'Ajouter un bloc finally', FALSE),
-- Quiz 14
(14, 'Utiliser password_verify($input, $db_hash)', TRUE), (14, 'Utiliser sha1() au lieu de md5()', FALSE), (14, 'Comparer avec == au lieu de ===', FALSE), (14, 'Hascher à nouveau le hash stocké', FALSE),
-- Quiz 15
(15, 'Utiliser if (strpos("Apple", "A") === false)', TRUE), (15, 'Utiliser str_contains() au lieu de strpos()', FALSE), (15, 'Faire if (strpos("Apple", "A") < 0)', FALSE), (15, 'Utiliser preg_match()', FALSE),
-- Quiz 16
(16, 'Vérifier is_array($list) ou is_countable($list) avant', TRUE), (16, 'Utiliser sizeof() au lieu de count()', FALSE), (16, 'Forcer le type : count((array)$list)', FALSE), (16, 'Cacher l''erreur avec @count()', FALSE),
-- Quiz 17
(17, 'Utiliser array_merge($arr1, $arr2) pour réindexer les clés', TRUE), (17, 'Utiliser array_push()', FALSE), (17, 'Inverser l''ordre : $arr2 + $arr1', FALSE), (17, 'Utiliser array_replace()', FALSE),
-- Quiz 18
(18, 'Ajouter le paramètre strict : in_array("1", [...], true)', TRUE), (18, 'Caster la chaîne : (int)"1"', FALSE), (18, 'Utiliser array_search() à la place', FALSE), (18, 'Vérifier d''abord le type avec is_string()', FALSE),
-- Quiz 19
(19, 'Mettre le tableau sur la même ligne que le return', TRUE), (19, 'Ajouter un point-virgule après return', FALSE), (19, 'Utiliser yield au lieu de return', FALSE), (19, 'Envelopper le tableau dans des parenthèses', FALSE),
-- Quiz 20
(20, 'Utiliser htmlspecialchars($_POST["comment"], ENT_QUOTES)', TRUE), (20, 'Utiliser urlencode() sur la variable', FALSE), (20, 'Faire un trim() de la chaîne', FALSE), (20, 'Mettre la variable entre des balises <pre>', FALSE);

-- ==========================================
-- INSERTION DES QUIZZES (JavaScript / ReactJS - ID 2)
-- ==========================================
INSERT INTO quizzes (id, technology_id, bug_description, code_snippet) VALUES 
(21, 2, 'L''interface ne se met pas à jour quand on clique sur le bouton pour incrémenter le compteur.', 'const [count, setCount] = useState(0);\nconst add = () => { count = count + 1; };'),
(22, 2, 'Boucle infinie détectée ! Le composant se re-rend sans arrêt jusqu''à faire crasher le navigateur.', 'useEffect(() => {\n  fetchData().then(data => setData(data));\n});'),
(23, 2, 'Avertissement React dans la console : "Each child in a list should have a unique key prop".', '<ul>\n  {items.map(item => <li>{item.name}</li>)}\n</ul>'),
(24, 2, 'La boucle affiche "3" trois fois dans la console au lieu de "0, 1, 2".', 'for (var i = 0; i < 3; i++) {\n  setTimeout(() => console.log(i), 1000);\n}'),
(25, 2, 'Le console.log affiche l''ancienne valeur du state juste après l''avoir modifié.', 'setCount(count + 1);\nconsole.log(count);'),
(26, 2, 'Erreur "TypeError: Cannot assign to read only property" lors de la modification des props.', 'function User(props) {\n  props.name = "Alice";\n  return <div>{props.name}</div>;\n}'),
(27, 2, 'La liste s''affiche vide sur l''écran car la fonction map ne retourne rien.', 'const list = arr.map(item => {\n  <p>{item}</p>\n});'),
(28, 2, 'Erreur fatale : "Objects are not valid as a React child".', 'const user = { name: "Bob" };\nreturn <div>{user}</div>;'),
(29, 2, 'Le compteur s''incrémente de 1 puis se bloque à cause d''une "stale closure".', 'useEffect(() => {\n  setInterval(() => setCount(count + 1), 1000);\n}, []);'),
(30, 2, 'Le chiffre "0" s''affiche sur l''interface quand le tableau items est vide.', 'return <div>{items.length && <List items={items} />}</div>;'),
(31, 2, 'Erreur React : "React Hook useState is called conditionally".', 'if (isValid) {\n  const [val, setVal] = useState(0);\n}'),
(32, 2, 'Erreur : "useEffect must not return anything besides a function".', 'useEffect(async () => {\n  const data = await fetchApi();\n}, []);'),
(33, 2, 'La fonction handleClick s''exécute toute seule dès l''affichage du composant.', '<button onClick={handleClick()}>Cliquez ici</button>'),
(34, 2, 'La page entière se rafraîchit (recharge) lors de la soumission du formulaire.', 'const submit = (e) => { sendData(); };\nreturn <form onSubmit={submit}>...</form>'),
(35, 2, 'La condition est validée car "0" équivaut à false avec la double égalité.', 'if ("0" == false) { console.log("Faux !"); }'),
(36, 2, 'Fuite de mémoire (Memory Leak) : le composant est détruit mais l''intervalle continue de tourner en arrière-plan.', 'useEffect(() => {\n  setInterval(updateTime, 1000);\n}, []);'),
(37, 2, 'Le state est muté directement, React ne détecte pas le changement et ne re-rend pas le composant.', 'const addItem = () => {\n  items.push("Nouveau");\n  setItems(items);\n};'),
(38, 2, 'Erreur fatale car typeof null retourne "object" en JavaScript.', 'if (typeof data === "object") {\n  console.log(data.id);\n}'),
(39, 2, 'Erreur "Cannot destructure property ''name'' of ''user'' as it is undefined".', 'const { name } = user;'),
(40, 2, 'Le style CSS ne s''applique pas et un warning apparaît dans la console concernant l''attribut HTML.', 'return <div class="container">Bonjour</div>;');

-- ==========================================
-- INSERTION DES RÉPONSES (JavaScript / ReactJS - 4 options par quiz)
-- ==========================================
INSERT INTO answers (quiz_id, solution_text, is_correct) VALUES 
-- Quiz 21
(21, 'Utiliser setCount(count + 1); pour mettre à jour le state.', TRUE), (21, 'Ajouter this. devant count = count + 1', FALSE), (21, 'Utiliser la méthode count.push(1)', FALSE), (21, 'Changer const en let lors de la déclaration du hook', FALSE),
-- Quiz 22
(22, 'Ajouter un tableau de dépendances vide [] à la fin du useEffect.', TRUE), (22, 'Remplacer useEffect par useState.', FALSE), (22, 'Ajouter return false; à la fin de fetchData.', FALSE), (22, 'Mettre le fetch dans un setTimeout.', FALSE),
-- Quiz 23
(23, 'Ajouter une propriété key (ex: key={item.id}) à l''élément <li>.', TRUE), (23, 'Ajouter un id="list" à la balise <ul>.', FALSE), (23, 'Utiliser forEach au lieu de map.', FALSE), (23, 'Envelopper le <li> dans un <React.Fragment>.', FALSE),
-- Quiz 24
(24, 'Remplacer var i = 0 par let i = 0 dans la boucle.', TRUE), (24, 'Remplacer setTimeout par setInterval.', FALSE), (24, 'Ajouter un bind(this) à la fonction anonyme.', FALSE), (24, 'Mettre le console.log en dehors du setTimeout.', FALSE),
-- Quiz 25
(25, 'C''est normal, setState est asynchrone. Utiliser useEffect pour lire la nouvelle valeur.', TRUE), (25, 'Le state n''a pas été modifié car il faut utiliser await setCount().', FALSE), (25, 'Il faut faire un console.log de setCount.', FALSE), (25, 'Le composant a craché en silence.', FALSE),
-- Quiz 26
(26, 'Les props sont en lecture seule. Il faut utiliser un state local pour les modifier.', TRUE), (26, 'Utiliser props.name.set("Alice");', FALSE), (26, 'Déclarer let props = this.props; avant de modifier.', FALSE), (26, 'Il faut utiliser Redux obligatoirement pour modifier une prop.', FALSE),
-- Quiz 27
(27, 'Ajouter le mot-clé return avant <p> ou retirer les accolades {}.', TRUE), (27, 'Remplacer map par filter.', FALSE), (27, 'Ajouter des parenthèses autour de item.', FALSE), (27, 'Utiliser echo <p>{item}</p>;', FALSE),
-- Quiz 28
(28, 'Afficher une propriété spécifique de l''objet, comme {user.name}.', TRUE), (28, 'Envelopper l''objet dans des crochets : {[user]}.', FALSE), (28, 'Utiliser toString() sur la div.', FALSE), (28, 'Remplacer les accolades par des parenthèses.', FALSE),
-- Quiz 29
(29, 'Utiliser la mise à jour fonctionnelle : setCount(c => c + 1).', TRUE), (29, 'Retirer le tableau de dépendances [] du useEffect.', FALSE), (29, 'Déclarer let count au lieu de const.', FALSE), (29, 'Utiliser window.setInterval.', FALSE),
-- Quiz 30
(30, 'Utiliser items.length > 0 ou !!items.length pour la condition.', TRUE), (30, 'Utiliser items.length === null.', FALSE), (30, 'Remplacer le && par un ||.', FALSE), (30, 'Ajouter un display: none en CSS.', FALSE),
-- Quiz 31
(31, 'Sortir le hook du if. Les hooks doivent toujours s''exécuter dans le même ordre.', TRUE), (31, 'Utiliser useConditionalState() au lieu de useState().', FALSE), (31, 'Ajouter useMemo() autour de la condition.', FALSE), (31, 'Cacher l''erreur avec un try...catch.', FALSE),
-- Quiz 32
(32, 'Créer une fonction async à l''intérieur du useEffect et l''appeler immédiatement.', TRUE), (32, 'Ajouter await devant le useEffect.', FALSE), (32, 'Remplacer useEffect par useAsyncEffect.', FALSE), (32, 'Retourner une promesse vide à la fin du hook.', FALSE),
-- Quiz 33
(33, 'Passer la référence de la fonction : onClick={handleClick}.', TRUE), (33, 'Utiliser onClick={() => handleClick()}.', FALSE), (33, 'Changer onClick par onChange.', FALSE), (33, 'Ajouter un event.preventDefault() dans la fonction.', FALSE),
-- Quiz 34
(34, 'Ajouter e.preventDefault(); au début de la fonction submit.', TRUE), (34, 'Ajouter un return false; à la fin de la fonction submit.', FALSE), (34, 'Utiliser un type="button" au lieu de type="submit" sur le bouton.', FALSE), (34, 'Remplacer onSubmit par onClick sur le formulaire.', FALSE),
-- Quiz 35
(35, 'Utiliser la comparaison stricte avec trois signes égal : ===.', TRUE), (35, 'Utiliser if ("0" = false).', FALSE), (35, 'Caster le false en string : "false".', FALSE), (35, 'Utiliser la fonction isFalse().', FALSE),
-- Quiz 36
(36, 'Retourner une fonction de nettoyage depuis le useEffect : return () => clearInterval(id);', TRUE), (36, 'Utiliser un setTimeout au lieu d''un setInterval.', FALSE), (36, 'Mettre le setInterval en dehors du composant.', FALSE), (36, 'Ajouter useMemo autour du useEffect.', FALSE),
-- Quiz 37
(37, 'Créer une copie du tableau : setItems([...items, "Nouveau"]);', TRUE), (37, 'Utiliser items.unshift() au lieu de push().', FALSE), (37, 'Forcer le rendu avec forceUpdate().', FALSE), (37, 'Utiliser setTimeout pour décaler le setItems.', FALSE),
-- Quiz 38
(38, 'Vérifier également que la donnée n''est pas nulle : if (data !== null && typeof ...).', TRUE), (38, 'Utiliser typeof data === "null".', FALSE), (38, 'Caster la donnée : (object) data.', FALSE), (38, 'Utiliser isObject(data).', FALSE),
-- Quiz 39
(39, 'S''assurer que user est défini, ou lui donner une valeur par défaut : const { name } = user || {};', TRUE), (39, 'Déstructurer dans un try...catch.', FALSE), (39, 'Utiliser const name = user?name;', FALSE), (39, 'Remplacer const par let.', FALSE),
-- Quiz 40
(40, 'Utiliser className au lieu de class en JSX.', TRUE), (40, 'Utiliser style="..." pour appliquer le CSS.', FALSE), (40, 'Mettre le nom de la classe entre accolades : class={"container"}.', FALSE), (40, 'Remplacer div par React.div.', FALSE);


-- ==========================================
-- INSERTION DES QUIZZES (C++ - ID 3)
-- ==========================================
INSERT INTO quizzes (id, technology_id, bug_description, code_snippet) VALUES 
(41, 3, 'Fuite de mémoire sévère (Memory Leak). L''application consomme de plus en plus de RAM.', 'void processData() {\n  int* data = new int[100];\n  // Traitement des données...\n}'),
(42, 3, 'Erreur de segmentation (Segfault) à l''exécution due à un dépassement de tableau.', 'int arr[5] = {1, 2, 3, 4, 5};\nfor(int i = 0; i <= 5; i++) {\n  cout << arr[i] << endl;\n}'),
(43, 3, 'La variable garde une valeur aléatoire car elle n''a pas été initialisée.', 'int count;\ncount += 5;\ncout << count;'),
(44, 3, 'La fonction swap ne modifie pas les variables originales dans le main.', 'void swap(int a, int b) {\n  int temp = a;\n  a = b;\n  b = temp;\n}'),
(45, 3, 'Le destructeur de la classe dérivée n''est pas appelé, provoquant une fuite de ressources.', 'class Base { public: ~Base() {} };\nclass Derived : public Base { ... };\nBase* b = new Derived();\ndelete b;'),
(46, 3, 'Erreur de compilation : "redefinition of class", le fichier d''en-tête est inclus plusieurs fois.', '// Fichier MyClass.h\nclass MyClass { ... };'),
(47, 3, 'Dangling pointer (Pointeur fou). Le programme plante car il tente d''accéder à une mémoire libérée.', 'int* ptr = new int(10);\ndelete ptr;\ncout << *ptr;'),
(48, 3, 'La boucle while s''exécute à l''infini car la condition n''est jamais fausse.', 'unsigned int i = 5;\nwhile(i >= 0) {\n  cout << i << endl;\n  i--;\n}'),
(49, 3, 'La chaîne de caractères est coupée au premier espace lors de la saisie utilisateur.', 'string name;\ncin >> name;\ncout << "Bonjour " << name;'),
(50, 3, 'Le programme affiche toujours "Vrai" même si x vaut 0.', 'int x = 0;\nif (x = 1) { cout << "Vrai"; }'),
(51, 3, 'Le tableau statique est renvoyé par la fonction, mais il est détruit à la fin de celle-ci.', 'int* getArray() {\n  int arr[5] = {1,2,3,4,5};\n  return arr;\n}'),
(52, 3, 'La division renvoie 0 au lieu de 0.5 car c''est une division entière.', 'int a = 1, b = 2;\nfloat result = a / b;'),
(53, 3, 'Le programme ne trouve pas la fonction cout.', 'int main() {\n  cout << "Test";\n  return 0;\n}'),
(54, 3, 'L''objet est copié au lieu d''être passé par référence, ce qui est très coûteux en performances.', 'void printVector(vector<int> v) {\n  // Affichage...\n}'),
(55, 3, 'L''opération bit à bit XOR annule la valeur au lieu de l''additionner.', 'int val = 5;\nval = val ^ val;'),
(56, 3, 'Un constructeur de copie par défaut fait une copie superficielle (shallow copy) et plante avec un double delete.', 'MyClass obj1;\nMyClass obj2 = obj1;\n// Les deux objets partagent le même pointeur interne.'),
(57, 3, 'La fonction strlen s''arrête au premier caractère nul (\\0) trouvé en mémoire.', 'char str[10] = {''A'', ''\\0'', ''B''};\ncout << strlen(str);'),
(58, 3, 'Un tableau alloué dynamiquement est supprimé comme un objet simple.', 'int* arr = new int[10];\ndelete arr;'),
(59, 3, 'La conversion (cast) coupe les décimales avant l''addition.', 'float a = 2.5;\nint b = (int)a + 2.5;'),
(60, 3, 'La macro se développe de manière inattendue, calculant (2 + 3 * 5) au lieu de (5 * 5).', '#define MULT(a, b) a * b\nint res = MULT(2 + 3, 5);');

-- ==========================================
-- INSERTION DES RÉPONSES (C++ - 4 options par quiz)
-- ==========================================
INSERT INTO answers (quiz_id, solution_text, is_correct) VALUES 
-- Quiz 41
(41, 'Ajouter delete[] data; à la fin de la fonction', TRUE), (41, 'Remplacer new int[100] par malloc(100)', FALSE), (41, 'Ajouter free(data); à la fin de la fonction', FALSE), (41, 'Mettre le pointeur à NULL au début de la fonction', FALSE),
-- Quiz 42
(42, 'Changer la condition de la boucle : i < 5', TRUE), (42, 'Déclarer le tableau avec une taille de 6 : int arr[6]', FALSE), (42, 'Commencer la boucle à i = 1', FALSE), (42, 'Utiliser arr.length() dans la condition', FALSE),
-- Quiz 43
(43, 'Initialiser la variable à zéro : int count = 0;', TRUE), (43, 'Utiliser static int count;', FALSE), (43, 'Caster le résultat en int', FALSE), (43, 'Ajouter un pointeur', FALSE),
-- Quiz 44
(44, 'Passer les arguments par référence : void swap(int& a, int& b)', TRUE), (44, 'Ajouter un return temp; à la fin', FALSE), (44, 'Utiliser des variables globales', FALSE), (44, 'Mettre la fonction en inline', FALSE),
-- Quiz 45
(45, 'Déclarer le destructeur de la classe de base comme virtuel : virtual ~Base() {}', TRUE), (45, 'Appeler explicitement b->~Derived();', FALSE), (45, 'Ne pas utiliser de pointeur Base*', FALSE), (45, 'Surcharger l''opérateur delete', FALSE),
-- Quiz 46
(46, 'Utiliser des Include Guards (#ifndef) ou #pragma once', TRUE), (46, 'Renommer la classe dans le fichier .cpp', FALSE), (46, 'Mettre le code dans le main', FALSE), (46, 'Utiliser extern class MyClass', FALSE),
-- Quiz 47
(47, 'Mettre le pointeur à nullptr après le delete : ptr = nullptr;', TRUE), (47, 'Ne pas utiliser delete', FALSE), (47, 'Utiliser delete[] au lieu de delete', FALSE), (47, 'Afficher la valeur avant le delete', FALSE),
-- Quiz 48
(48, 'Utiliser un int signé (int i = 5;) ou changer la condition', TRUE), (48, 'Ajouter un break; à la fin de la boucle', FALSE), (48, 'Changer while par do...while', FALSE), (48, 'Retirer le i--', FALSE),
-- Quiz 49
(49, 'Utiliser getline(cin, name); au lieu de cin >> name;', TRUE), (49, 'Utiliser cin.get(name)', FALSE), (49, 'Déclarer name comme un char array', FALSE), (49, 'Ajouter std::ws avant cin', FALSE),
-- Quiz 50
(50, 'Utiliser la comparaison avec le double égal : if (x == 1)', TRUE), (50, 'Changer int x = 0 en bool x = false', FALSE), (50, 'Utiliser if (1 = x)', FALSE), (50, 'Ajouter un else', FALSE),
-- Quiz 51
(51, 'Allouer le tableau dynamiquement avec new ou utiliser std::vector', TRUE), (51, 'Rendre la fonction static', FALSE), (51, 'Retourner un pointeur vers le premier élément', FALSE), (51, 'Passer le tableau par valeur', FALSE),
-- Quiz 52
(52, 'Caster l''un des opérandes en float : float result = (float)a / b;', TRUE), (52, 'Déclarer a et b comme des const int', FALSE), (52, 'Utiliser la fonction div()', FALSE), (52, 'Mettre le résultat dans un int', FALSE),
-- Quiz 53
(53, 'Ajouter #include <iostream> et using namespace std; au début', TRUE), (53, 'Remplacer cout par printf', FALSE), (53, 'Déclarer cout comme une variable', FALSE), (53, 'Ajouter un return 1;', FALSE),
-- Quiz 54
(54, 'Passer le vecteur par référence constante : void printVector(const vector<int>& v)', TRUE), (54, 'Passer un pointeur vers le vecteur', FALSE), (54, 'Utiliser un tableau statique à la place', FALSE), (54, 'Déplacer la boucle dans le main', FALSE),
-- Quiz 55
(55, 'L''opérateur ^ est un XOR binaire. Utiliser val = val + val; pour additionner.', TRUE), (55, 'Utiliser val = val | val;', FALSE), (55, 'Utiliser val = val & val;', FALSE), (55, 'Ajouter un cast (int)', FALSE),
-- Quiz 56
(56, 'Implémenter un constructeur de copie personnalisé pour faire une copie profonde (deep copy)', TRUE), (56, 'Ne pas copier l''objet', FALSE), (56, 'Utiliser std::move', FALSE), (56, 'Déclarer le constructeur comme explicite', FALSE),
-- Quiz 57
(57, 'La fonction strlen fonctionne ainsi, elle retourne 1 car elle s''arrête au \0', TRUE), (57, 'La fonction strlen retourne la taille totale du tableau en mémoire', FALSE), (57, 'Il faut utiliser sizeof() au lieu de strlen()', FALSE), (57, 'Le tableau est mal déclaré', FALSE),
-- Quiz 58
(58, 'Utiliser delete[] arr; pour supprimer un tableau alloué avec new[]', TRUE), (58, 'Utiliser delete arr[];', FALSE), (58, 'Ne rien faire, le garbage collector s''en charge', FALSE), (58, 'Appeler free(arr);', FALSE),
-- Quiz 59
(59, 'Faire l''addition avant le cast : int b = (int)(a + 2.5);', TRUE), (59, 'Changer a en int', FALSE), (59, 'Utiliser round()', FALSE), (59, 'Déclarer b comme un float', FALSE),
-- Quiz 60
(60, 'Mettre des parenthèses dans la macro : #define MULT(a, b) ((a) * (b))', TRUE), (60, 'Utiliser une fonction inline à la place', FALSE), (60, 'Ne pas utiliser d''espaces dans l''appel', FALSE), (60, 'Changer MULT par ADD', FALSE);


-- ==========================================
-- INSERTION DES QUIZZES (C# - ID 4)
-- ==========================================
INSERT INTO quizzes (id, technology_id, bug_description, code_snippet) VALUES 
(61, 4, 'Erreur "Collection was modified; enumeration operation may not execute" lors de l''exécution.', 'List<string> names = new List<string>{"Alice", "Bob"};\nforeach(var name in names) {\n  if(name == "Bob") names.Remove(name);\n}'),
(62, 4, 'NullReferenceException. L''application crash si l''utilisateur n''est pas trouvé en base.', 'var user = db.Users.FirstOrDefault(u => u.Id == 99);\nConsole.WriteLine(user.Name);'),
(63, 4, 'La modification de struct1 ne se reflète pas sur struct2 car c''est un type valeur.', 'struct Point { public int X; }\nPoint p1 = new Point { X = 10 };\nPoint p2 = p1;\np1.X = 20;\nConsole.WriteLine(p2.X);'),
(64, 4, 'Deadlock ! L''application se fige car on attend le résultat d''une tâche asynchrone sur le thread principal.', 'public string GetData() {\n  var task = HttpClient.GetStringAsync(url);\n  return task.Result;\n}'),
(65, 4, 'Le dictionnaire lance une KeyNotFoundException si la clé n''existe pas.', 'Dictionary<int, string> dict = new Dictionary<int, string>();\nstring val = dict[5];'),
(66, 4, 'La requête LINQ s''exécute plusieurs fois (Multiple Enumeration), ce qui ralentit considérablement l''application.', 'var query = db.Users.Where(u => u.IsActive);\nint count = query.Count();\nvar list = query.ToList();'),
(67, 4, 'Le bloc "finally" masque l''exception d''origine si une erreur se produit à l''intérieur.', 'try {\n  throw new Exception("Erreur 1");\n} finally {\n  throw new Exception("Erreur 2");\n}'),
(68, 4, 'La division renvoie 0 au lieu de 0.5 (division entière).', 'int a = 1; int b = 2;\ndouble result = a / b;'),
(69, 4, 'Erreur de compilation : impossible d''utiliser le mot-clé "await" dans cette méthode.', 'public void Process() {\n  await Task.Delay(1000);\n}'),
(70, 4, 'La concaténation de chaînes dans une grande boucle génère énormément de déchets (Garbage Collection).', 'string s = "";\nfor(int i=0; i<10000; i++) {\n  s += i.ToString();\n}'),
(71, 4, 'La méthode retourne toujours false, même si les chaînes ont le même contenu, à cause de la casse.', 'string s1 = "Test";\nstring s2 = "test";\nbool match = (s1 == s2);'),
(72, 4, 'Un memory leak silencieux avec un Event Handler. L''objet n''est jamais détruit.', 'public Form1() {\n  Publisher.OnEvent += HandleEvent;\n}'),
(73, 4, 'Erreur "Cannot implicitly convert type ''double'' to ''int''".', 'int score = 9.5;'),
(74, 4, 'Le Singleton n''est pas "Thread-Safe", deux instances peuvent être créées simultanément.', 'public static Singleton Instance {\n  get {\n    if(_instance == null) _instance = new Singleton();\n    return _instance;\n  }\n}'),
(75, 4, 'L''instruction "throw ex;" réinitialise la StackTrace, faisant perdre l''origine de l''erreur.', 'catch(Exception ex) {\n  Log(ex);\n  throw ex;\n}'),
(76, 4, 'La méthode de la classe de base est appelée au lieu de celle de la classe enfant (le polymorphisme ne fonctionne pas).', 'class Base { public void Print() { Console.WriteLine("Base"); } }\nclass Child : Base { public void Print() { Console.WriteLine("Child"); } }\nBase obj = new Child();\nobj.Print();'),
(77, 4, 'L''utilisation de Select avec une méthode asynchrone retourne un IEnumerable<Task> au lieu d''attendre les résultats.', 'var results = users.Select(async u => await GetDetailsAsync(u.Id));'),
(78, 4, 'L''objet "Timer" est collecté par le Garbage Collector immédiatement après la fin de la méthode, arrêtant les ticks.', 'public void StartTimer() {\n  var timer = new System.Threading.Timer(Callback, null, 0, 1000);\n}'),
(79, 4, 'La méthode "SingleOrDefault" crash car il y a plusieurs éléments qui correspondent à la condition.', 'var user = db.Users.SingleOrDefault(u => u.Name == "Alice");'),
(80, 4, 'Le stream n''est pas fermé correctement si une exception se produit.', 'var stream = new FileStream("data.txt", FileMode.Open);\n// ... traitement ...\nstream.Close();');

-- ==========================================
-- INSERTION DES RÉPONSES (C# - 4 options par quiz)
-- ==========================================
INSERT INTO answers (quiz_id, solution_text, is_correct) VALUES 
-- Quiz 61
(61, 'Utiliser une boucle for inversée (for int i = names.Count - 1...) pour supprimer', TRUE), (61, 'Ajouter un break; juste après le Remove(name);', FALSE), (61, 'Utiliser un IEnumerator manuel', FALSE), (61, 'Remplacer List par Array', FALSE),
-- Quiz 62
(62, 'Utiliser l''opérateur de null-condition : user?.Name', TRUE), (62, 'Utiliser SingleOrDefault au lieu de FirstOrDefault', FALSE), (62, 'Mettre le code dans un try/catch vide', FALSE), (62, 'Initialiser user avec un new User() avant', FALSE),
-- Quiz 63
(63, 'C''est le comportement normal d''une struct. Changer struct en class si on veut un type référence.', TRUE), (63, 'Utiliser le mot-clé ref lors de l''assignation : Point p2 = ref p1;', FALSE), (63, 'Ajouter public static int X;', FALSE), (63, 'Implémenter ICloneable', FALSE),
-- Quiz 64
(64, 'Rendre la méthode async Task<string> et utiliser await HttpClient.GetStringAsync(url);', TRUE), (64, 'Utiliser task.GetAwaiter().GetResult();', FALSE), (64, 'Mettre task.Wait(); avant le return', FALSE), (64, 'Lancer la tâche dans un Task.Run()', FALSE),
-- Quiz 65
(65, 'Utiliser dict.TryGetValue(5, out string val);', TRUE), (65, 'Utiliser dict.ContainsKey(5) après l''accès', FALSE), (65, 'Utiliser dict[5] ?? "default";', FALSE), (65, 'Changer Dictionary en Hashtable', FALSE),
-- Quiz 66
(66, 'Ajouter .ToList() juste après le .Where() pour matérialiser la requête une seule fois.', TRUE), (66, 'Retirer le .Count() et calculer manuellement', FALSE), (66, 'Mettre la requête en cache avec [MemoryCache]', FALSE), (66, 'Remplacer IQueryable par IEnumerable', FALSE),
-- Quiz 67
(67, 'Ne pas lever de nouvelle exception dans le finally sans sauvegarder/gérer la première.', TRUE), (67, 'Remplacer finally par catch', FALSE), (67, 'Ajouter un throw; dans le finally', FALSE), (67, 'Envelopper le finally dans un autre try/catch', FALSE),
-- Quiz 68
(68, 'Caster l''un des entiers : double result = (double)a / b;', TRUE), (68, 'Changer a et b en float', FALSE), (68, 'Utiliser Math.Divide()', FALSE), (68, 'Mettre le résultat dans un int puis caster', FALSE),
-- Quiz 69
(69, 'Ajouter le mot-clé "async" à la signature : public async void Process() (ou Task)', TRUE), (69, 'Remplacer await par wait', FALSE), (69, 'Mettre Task.Delay dans un Thread.Sleep()', FALSE), (69, 'Retirer le mot clé await', FALSE),
-- Quiz 70
(70, 'Utiliser la classe StringBuilder pour concaténer.', TRUE), (70, 'Appeler GC.Collect() à chaque itération', FALSE), (70, 'Utiliser string.Concat(s, i)', FALSE), (70, 'Utiliser l''interpolation : $"{s}{i}"', FALSE),
-- Quiz 71
(71, 'Utiliser string.Equals(s1, s2, StringComparison.OrdinalIgnoreCase);', TRUE), (71, 'Utiliser s1.ToLower() == s2.ToLower() (moins performant)', FALSE), (71, 'Utiliser la méthode s1.Contains(s2)', FALSE), (71, 'Utiliser s1.CompareTo(s2) == 1', FALSE),
-- Quiz 72
(72, 'Se désabonner de l''événement lors de la destruction (ex: Publisher.OnEvent -= HandleEvent; dans Dispose)', TRUE), (72, 'Déclarer l''événement comme static', FALSE), (72, 'Mettre HandleEvent à null', FALSE), (72, 'Utiliser un WeakReference manuellement partout', FALSE),
-- Quiz 73
(73, 'Utiliser un cast explicite (int)9.5 ou Convert.ToInt32(9.5).', TRUE), (73, 'Changer int en float', FALSE), (73, 'Utiliser int.Parse("9.5")', FALSE), (73, 'Utiliser int.TryParse()', FALSE),
-- Quiz 74
(74, 'Utiliser lock (padlock) ou Lazy<T> pour garantir l''initialisation unique.', TRUE), (74, 'Rendre la propriété async', FALSE), (74, 'Mettre if(_instance == null) deux fois', FALSE), (74, 'Changer public static en private static', FALSE),
-- Quiz 75
(75, 'Utiliser uniquement "throw;" pour conserver la StackTrace complète.', TRUE), (75, 'Utiliser throw new Exception(ex.Message);', FALSE), (75, 'Retourner null au lieu de throw', FALSE), (75, 'Mettre throw; avant le Log()', FALSE),
-- Quiz 76
(76, 'Ajouter virtual dans la classe Base et override dans Child.', TRUE), (76, 'Ajouter le mot-clé new dans Child', FALSE), (76, 'Caster obj en Child avant l''appel', FALSE), (76, 'Rendre la méthode abstraite', FALSE),
-- Quiz 77
(77, 'Utiliser Task.WhenAll(users.Select(...)) pour attendre toutes les tâches.', TRUE), (77, 'Remplacer Select par Foreach', FALSE), (77, 'Ajouter await devant Select', FALSE), (77, 'Retirer le mot clé async dans le lambda', FALSE),
-- Quiz 78
(78, 'Stocker l''instance du Timer dans un champ de classe (champ privé) pour le garder en vie.', TRUE), (78, 'Appeler GC.KeepAlive(timer);', FALSE), (78, 'Utiliser un Thread au lieu d''un Timer', FALSE), (78, 'Ajouter un while(true) à la fin de la méthode', FALSE),
-- Quiz 79
(79, 'Utiliser FirstOrDefault si on s''attend à plusieurs résultats et qu''on veut le premier.', TRUE), (79, 'Utiliser Single() pour ignorer les doublons', FALSE), (79, 'Utiliser Take(1)', FALSE), (79, 'Mettre la requête dans un try/catch et ignorer l''erreur', FALSE),
-- Quiz 80
(80, 'Envelopper l''utilisation du stream dans un bloc "using" ou utiliser finally pour appeler Close().', TRUE), (80, 'Appeler GC.Collect()', FALSE), (80, 'Mettre stream = null; à la fin', FALSE), (80, 'Fermer le stream avant le traitement', FALSE);


-- ==========================================
-- INSERTION DES QUIZZES (Mobile - ID 5)
-- ==========================================
INSERT INTO quizzes (id, technology_id, bug_description, code_snippet) VALUES 
(81, 5, '(React Native) Grosse perte de fluidité et de performances lors de l''affichage d''une liste de 1000 éléments.', 'return (\n  <ScrollView>\n    {data.map(item => <ListItem key={item.id} data={item} />)}\n  </ScrollView>\n);'),
(82, 5, '(Flutter) Erreur de compilation car la méthode build() ne retourne pas un widget valide ou modifie l''état illégalement.', 'Widget build(BuildContext context) {\n  setState(() { count++; });\n  return Text("Count: $count");\n}'),
(83, 5, '(React Native) Le texte déborde de l''écran sur les petits téléphones au lieu de passer à la ligne.', 'return (\n  <View style={{ flexDirection: "row" }}>\n    <Text>Un texte très très long qui ne tient pas...</Text>\n  </View>\n);'),
(84, 5, '(Flutter) Exception "setState() called after dispose()". L''application plante si on quitte l''écran pendant un chargement réseau.', 'Future<void> loadData() async {\n  var data = await api.get();\n  setState(() { items = data; });\n}'),
(85, 5, '(React Native) Erreur "Cannot read property ''navigate'' of undefined" lors du clic sur un bouton.', 'const MyScreen = () => {\n  return <Button onPress={() => navigation.navigate("Home")} />\n};'),
(86, 5, '(Flutter) L''interface ne se met pas à jour quand on ajoute un élément à la liste dans un StatefulWidget.', 'void addItem() {\n  myList.add("New Item");\n}'),
(87, 5, '(React Native) L''image ne s''affiche pas à l''écran.', 'return <Image source={{ uri: "https://example.com/img.png" }} />;'),
(88, 5, '(Flutter) Le bouton prend toute la largeur et la hauteur de l''écran.', 'Widget build(BuildContext context) {\n  return ElevatedButton(onPressed: () {}, child: Text("Click"));\n}'),
(89, 5, '(React Native) Le clavier cache le champ de texte (TextInput) situé en bas de l''écran lors de la saisie.', 'return (\n  <View style={{ flex: 1 }}>\n    <TextInput style={{ position: "absolute", bottom: 0 }} />\n  </View>\n);'),
(90, 5, '(Flutter) Erreur "A RenderFlex overflowed by 20 pixels on the right".', 'Row(\n  children: [ Container(width: 500, child: Text("Trop grand")) ],\n)'),
(91, 5, '(React Native) Le composant enfant ne reçoit pas la mise à jour du state du composant parent.', 'const Child = React.memo(({ data }) => <Text>{data.value}</Text>);\n// Parent met à jour data.value = 2 sans changer l''objet data'),
(92, 5, '(Flutter) La liste ListView.builder ne défile pas (scroll impossible).', 'Column(\n  children: [\n    ListView.builder(itemBuilder: (ctx, i) => Text("Item $i"))\n  ],\n)'),
(93, 5, '(React Native) L''application crash sur iOS avec "Invariant Violation: Text strings must be rendered within a <Text> component".', 'return (\n  <View>\n    {user.name && <Text>{user.name}</Text>}\n  </View>\n); // user.name est une chaîne vide ""'),
(94, 5, '(Flutter) Le FutureBuilder s''exécute en boucle infinie (requête réseau répétée).', 'Widget build(BuildContext context) {\n  return FutureBuilder(future: fetchData(), builder: (c, s) => ...);\n}'),
(95, 5, '(React Native) Erreur "VirtualizedLists should never be nested inside plain ScrollViews".', 'return (\n  <ScrollView>\n    <FlatList data={data} renderItem={...} />\n  </ScrollView>\n);'),
(96, 5, '(Flutter) Erreur lors de la navigation : "Navigator operation requested with a context that does not include a Navigator".', 'void main() {\n  runApp(MaterialApp(home: Scaffold(body: \n    ElevatedButton(onPressed: () => Navigator.push(...)))));\n}'),
(97, 5, '(React Native) Les styles ne s''appliquent pas correctement. flexDirection "column" ne fonctionne pas.', 'return <View style="flexDirection: column"> ... </View>'),
(98, 5, '(Flutter) L''état est perdu (le widget se réinitialise) lors du défilement dans une ListView.', 'ListView.builder(\n  itemBuilder: (context, index) => MyStatefulWidget()\n)'),
(99, 5, '(React Native) L''alerte native ne s''affiche pas.', 'const showAlert = () => {\n  Alert("Attention", "Message");\n};'),
(100, 5, '(Flutter) Le hot reload ne met pas à jour le state d''une variable initialisée dans initState().', 'int _counter;\nvoid initState() {\n  super.initState();\n  _counter = 0;\n}');

-- ==========================================
-- INSERTION DES RÉPONSES (Mobile - 4 options par quiz)
-- ==========================================
INSERT INTO answers (quiz_id, solution_text, is_correct) VALUES 
-- Quiz 81
(81, 'Utiliser une <FlatList> qui ne rend que les éléments visibles à l''écran.', TRUE), (81, 'Ajouter un style { flex: 1 } au ScrollView.', FALSE), (81, 'Retirer la propriété key={item.id}.', FALSE), (81, 'Envelopper le code dans un composant <Suspense>.', FALSE),
-- Quiz 82
(82, 'Déplacer setState dans une méthode d''interaction (ex: onTap, onPressed) et non dans build().', TRUE), (82, 'Mettre setState dans un Future.delayed.', FALSE), (82, 'Utiliser un StatelessWidget à la place.', FALSE), (82, 'Enlever le Text() et retourner setState directement.', FALSE),
-- Quiz 83
(83, 'Ajouter flexShrink: 1 ou flex: 1 sur l''élément Text.', TRUE), (83, 'Ajouter overflow: "hidden" sur la View.', FALSE), (83, 'Utiliser <Text numberOfLines={1}> obligatoirement.', FALSE), (83, 'Mettre flexDirection: "column".', FALSE),
-- Quiz 84
(84, 'Vérifier if (mounted) avant d''appeler setState().', TRUE), (84, 'Mettre setState dans un bloc try/catch.', FALSE), (84, 'Utiliser await setState(...).', FALSE), (84, 'Retirer le mot clé async de la fonction.', FALSE),
-- Quiz 85
(85, 'Passer la prop { navigation } au composant : const MyScreen = ({ navigation }) => ...', TRUE), (85, 'Importer navigation depuis "react".', FALSE), (85, 'Utiliser window.location.href.', FALSE), (85, 'Changer "Home" par "/"', FALSE),
-- Quiz 86
(86, 'Envelopper myList.add(...) à l''intérieur d''un appel setState(() { ... }).', TRUE), (86, 'Ajouter un await devant myList.add.', FALSE), (86, 'Utiliser un StatelessWidget.', FALSE), (86, 'Appeler forceUpdate() après.', FALSE),
-- Quiz 87
(87, 'Spécifier impérativement une largeur et une hauteur dans le style (ex: width: 100, height: 100).', TRUE), (87, 'Remplacer source={{ uri: ... }} par src="..."', FALSE), (87, 'Ajouter resizeMode="contain" obligatoirement.', FALSE), (87, 'Télécharger l''image localement car les URI ne marchent pas.', FALSE),
-- Quiz 88
(88, 'Envelopper l''ElevatedButton dans un Center(), Align() ou Column() pour limiter sa taille.', TRUE), (88, 'Ajouter un paramètre width: 100 à l''ElevatedButton.', FALSE), (88, 'Utiliser un TextButton à la place.', FALSE), (88, 'C''est le comportement normal sous iOS uniquement.', FALSE),
-- Quiz 89
(89, 'Envelopper le composant avec un <KeyboardAvoidingView>.', TRUE), (89, 'Changer position: "absolute" en position: "fixed".', FALSE), (89, 'Mettre un margin-bottom de 300px.', FALSE), (89, 'Utiliser e.preventDefault() sur le TextInput.', FALSE),
-- Quiz 90
(90, 'Envelopper le Container dans un Expanded() ou Flexible().', TRUE), (90, 'Augmenter la taille du Row en CSS.', FALSE), (90, 'Remplacer Row par Column.', FALSE), (90, 'Mettre un padding négatif.', FALSE),
-- Quiz 91
(91, 'Le parent doit passer une nouvelle référence d''objet pour déclencher le rendu avec React.memo.', TRUE), (91, 'Retirer React.memo car il est buggé.', FALSE), (91, 'Ajouter un useEffect dans le Child.', FALSE), (91, 'Utiliser let data au lieu de const.', FALSE),
-- Quiz 92
(92, 'Envelopper la ListView dans un Expanded() ou ajouter shrinkWrap: true.', TRUE), (92, 'Ajouter scrollDirection: Axis.horizontal.', FALSE), (92, 'Remplacer ListView.builder par ListView.', FALSE), (92, 'Mettre la Column dans un Container.', FALSE),
-- Quiz 93
(93, 'Vérifier avec !!user.name ou user.name.length > 0 (React Native évalue le "" et crash si ce n''est pas un booléen).', TRUE), (93, 'Retirer les accolades autour de {user.name}.', FALSE), (93, 'Utiliser une <Text> englobante à la place de <View>.', FALSE), (93, 'Caster en Int : (int)user.name', FALSE),
-- Quiz 94
(94, 'Stocker le Future dans une variable d''état (dans initState) au lieu de l''appeler directement dans build().', TRUE), (94, 'Mettre un await devant FutureBuilder.', FALSE), (94, 'Ajouter un break dans le builder.', FALSE), (94, 'Utiliser StreamBuilder à la place.', FALSE),
-- Quiz 95
(95, 'Ne pas mettre de FlatList dans un ScrollView. Utiliser les ListHeaderComponent de FlatList si besoin.', TRUE), (95, 'Remplacer FlatList par SectionList.', FALSE), (95, 'Ajouter scrollEnabled={false} au ScrollView.', FALSE), (95, 'Mettre un zIndex supérieur à la FlatList.', FALSE),
-- Quiz 96
(96, 'Créer un widget séparé ou utiliser un Builder pour avoir un BuildContext enfant de MaterialApp.', TRUE), (96, 'Utiliser Navigator.pop() au lieu de push().', FALSE), (96, 'Ajouter un async/await.', FALSE), (96, 'Retirer le MaterialApp.', FALSE),
-- Quiz 97
(97, 'Utiliser un objet pour les styles en React Native : style={{ flexDirection: "column" }}', TRUE), (97, 'Changer column en "col".', FALSE), (97, 'Utiliser class="flex-column".', FALSE), (97, 'Ajouter display: "flex".', FALSE),
-- Quiz 98
(98, 'Utiliser AutomaticKeepAliveClientMixin dans l''état du MyStatefulWidget.', TRUE), (98, 'Mettre cache: true dans le ListView.builder.', FALSE), (98, 'Remplacer par un StatelessWidget.', FALSE), (98, 'Stocker l''index dans une variable globale.', FALSE),
-- Quiz 99
(99, 'Utiliser la méthode Alert.alert("Attention", "Message");', TRUE), (99, 'Utiliser window.alert().', FALSE), (99, 'Ajouter le composant <Alert> dans le JSX.', FALSE), (99, 'Passer l''alerte dans un useEffect.', FALSE),
-- Quiz 100
(100, 'C''est normal. initState n''est appelé qu''une fois. Faire un Full Restart de l''application.', TRUE), (100, 'Appeler setState dans initState.', FALSE), (100, 'Mettre la variable _counter en final.', FALSE), (100, 'Utiliser didChangeDependencies à la place.', FALSE);