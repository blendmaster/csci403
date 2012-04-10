/* zoolicious schema */

create table zoolicious.zoos (
    id int not null auto_increment primary key,
    name varchar(128) not null
);

create table zoolicious.habitats (
    id int not null auto_increment primary key,
    name varchar(255) not null,
    capacity int not null check (capacity > 0 and capacity < 50),
    location varchar(255) not null,
    description varchar(255) not null,
    zoo_id int not null,
    index (zoo_id),
    foreign key (zoo_id) references zoos(id)
);

create table zoolicious.animals (
    id int not null auto_increment primary key,
    name varchar(255) not null,
    description varchar(255) not null,
    cuteness int not null check (cuteness >= 1 and cuteness <= 10),
    habitat_id int not null,
    index (habitat_id),
    foreign key (habitat_id) references habitats(id)
);

create table zoolicious.feed (
    id int not null auto_increment primary key,
    name varchar(255) not null,
    delicious boolean
);

create table zoolicious.users (
    id int not null auto_increment primary key,
    username varchar(16) not null unique check ( length(username) >= 9 and length(username) <= 16 ),
    password varchar(128) not null
);

create table zoolicious.animals_feeds (
    animal_id int not null,
    index (animal_id),
    foreign key (animal_id) references animals(id),
    feed_id int not null,
    index (feed_id),
    foreign key (feed_id) references feed(id)
);

create table zoolicious.animals_users (
    animal_id int not null,
    index (animal_id),
    foreign key (animal_id) references animals(id),
    user_id int unique not null,
    index (user_id),
    foreign key (user_id) references users(id)
);