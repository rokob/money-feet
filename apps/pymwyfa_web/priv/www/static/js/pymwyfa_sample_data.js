{
  users: function(idx) {
	users_ = [
    {"id": "u1",
     "disp_name": "Andy",
     "full_name": "Andy Ledvina",
     "charities": ["c1"],
     "races": ["r3"],
     "img": "http://www.google.com"
    },
    {"id": "u2",
     "disp_name": "Wolf",
     "full_name": "Wolf Gang",
     "charities": ["c1","c2"],
     "races": [],
     "img": "http://www.google.com"
    },
	{"id": "u3",
     "disp_name": "Lauren",
     "full_name": "Lauren Runner",
     "charities": [],
     "races": ["r1"],
     "img": "http://www.google.com"
    },
  ];
  return users_[idx-1];
  };
  races: function(idx) {
	races_ = [
    {"id": "r1",
     "name": "Chicago Half Marathon",
     "location": "Chicago, IL, USA",
     "lat": 127.0,
     "lng": -50.0,
     "distance": 13.1,
     "units": "mi",
     "datetime": "2012-08-31T7:00:00Z0000",
     "url": "http://www.chicagohalfmarathon.com",
     "img": "http://www.chicagohalfmarathon.com/img/logo.jpg"
    },
    {"id": "r2",
     "name": "San Francisco Marathon",
     "location": "San Francisco, CA, USA",
     "lat": 107.0,
     "lng": -100.0,
     "distance": 26.2,
     "units": "mi",
     "datetime": "2012-09-15T8:30:00Z0000",
     "url": "http://www.sfmarathon.com",
     "img": "http://www.sfmarathon.com/img/logo.jpg"
    },
	{"id": "r3",
     "name": "Bay To Breakers",
     "location": "San Francisco, CA, USA",
     "lat": 107.0,
     "lng": -100.0,
     "distance": 10,
     "units": "km",
     "datetime": "2012-06-01T9:30:00Z0000",
     "url": "http://www.sfmarathon.com",
     "img": "http://www.sfmarathon.com/img/logo.jpg"
    }
  ];
  return races_[idx-1];
  };
  challenges: function(idx) {
	challenges_  = [
    {"from": "u1",
     "to": "u3",
     "race": "r1",
     "flat": 10,
     "bonus": 10,
     "scale": 1,
     "unit": 30,
     "charity": "default"
    },
    {"from": "u2",
     "to": "u1",
     "race": "r3",
     "flat": 0,
     "bonus": 5,
     "scale": 5,
     "unit": 60,
     "charity": "c1"
    }
  ];
  return challenges_[idx-1];
  };
  charities: function(idx) {
	charities_ = [
    {"id": "c1",
     "name": "Autism Speaks",
     "img": "http://www.someimage.com",
     "url": "http://www.autismspeaks.com",
     "blurb": "Autism Speaks supports people with blah blah blah"
    },
    {"id": "c2",
     "name": "Livestrong",
     "img": "http://www.someyellowimage.com",
     "url": "http://www.livestrong.com",
     "blurb": "The Livestrong Foundation supports people with blah blah blah"
    }
  ];
  return charities_[idx-1];
  };
  get_user_page: function(uid) {
  user_pages = {
    "u1": {
	  "info": users(1),
	  "races": [
	    races(3)
	  ],
	  "charities": [
	    charities(1)
	  ]
    },
    "u2": {
	  "info": users(2),
	  "races": [
	  ],
	  "charities": [
	    charities(1),
	    charities(2)
	  ]
    },
    "u3": {
	  "info": users(3),
	  "races": [
	    races(1)
	  ],
	  "charities": [
	  ]
    }
  };
  return user_pages[uid];
  };
  get_user_race_page: function(uid, rid) {
  user_race_pages = {
	"u1:r2": {
	  "user": users(1),
	  "race": races(3),
	  "goal": "2160",
	  "result": "",
	  "supporters": 1,
	  "bib": "887",
	  "challenges": [
	    challenges(2)
	  ],
	  "charities": [
	    charities(1)
	  ]
	},
	"u3:r1": {
		"user": users(3),
		"race": races(1),
		"goal": "5400",
		"result": "",
		"supporters": 1,
		"bib": "",
		"challenges": [
		  challenges(1)
		],
		"charities": [
		]
	}
  };
  return user_race_pages[uid+":"+rid];
  };
};
