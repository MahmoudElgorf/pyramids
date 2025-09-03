class DemoSite {
  final String name, location, era, period, description;
  const DemoSite(this.name, this.location, this.era, this.period, this.description);
}

const demoSites = <DemoSite>[
  DemoSite('Giza Pyramids','Giza','Old Kingdom','c. 26th century BCE','Khufu, Khafre, Menkaure pyramids; iconic plateau with the Great Sphinx.'),
  DemoSite('Saqqara (Step Pyramid of Djoser)','Giza / Saqqara','Old Kingdom','27th century BCE','Earliest large-scale cut-stone construction; funerary complex by Imhotep.'),
  DemoSite('Dahshur (Bent & Red Pyramids)','Giza / Dahshur','Old Kingdom','c. 26th century BCE','Sneferu’s Bent and Red Pyramids—pivotal in the evolution of pyramid design.'),
  DemoSite('Karnak Temple','Luxor','New Kingdom','c. 20th–16th century BCE','Massive complex dedicated primarily to Amun; hypostyle hall and obelisks.'),
  DemoSite('Valley of the Kings','Luxor (West Bank)','New Kingdom','16th–11th century BCE','Royal necropolis with rich tombs including Tutankhamun; desert canyons.'),
  DemoSite('Philae Temple','Aswan','Greco-Roman','Ptolemaic era','Temple of Isis relocated to Agilkia Island; graceful colonnades on the Nile.'),
];
