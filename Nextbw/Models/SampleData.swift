import SwiftUI

// MARK: - Sample Quizzes

struct SampleData {

    // MARK: - Quizzes

    static let quizzes: [Quiz] = [
        Quiz(
            id: UUID(),
            title: "Les antibiotiques",
            description: "Testez vos connaissances sur les grandes familles d'antibiotiques",
            category: .medicaments,
            difficulty: .intermediaire,
            questions: antibiotiquesQuestions,
            xpReward: 80,
            estimatedMinutes: 5,
            icon: "pills.fill"
        ),
        Quiz(
            id: UUID(),
            title: "Conseil au comptoir",
            description: "Les bons reflexes pour le conseil officinal au quotidien",
            category: .conseil,
            difficulty: .debutant,
            questions: conseilQuestions,
            xpReward: 60,
            estimatedMinutes: 4,
            icon: "bubble.left.and.bubble.right.fill"
        ),
        Quiz(
            id: UUID(),
            title: "Lecture d'ordonnance",
            description: "Savoir analyser et valider une ordonnance",
            category: .ordonnance,
            difficulty: .avance,
            questions: ordonnanceQuestions,
            xpReward: 100,
            estimatedMinutes: 7,
            icon: "doc.text.fill"
        ),
        Quiz(
            id: UUID(),
            title: "Phytotherapie essentielle",
            description: "Les plantes incontournables a connaitre",
            category: .phytotherapie,
            difficulty: .debutant,
            questions: phytoQuestions,
            xpReward: 60,
            estimatedMinutes: 4,
            icon: "leaf.fill"
        ),
        Quiz(
            id: UUID(),
            title: "Dermo-cosmetique",
            description: "Conseils en dermo-cosmetique et soins de la peau",
            category: .dermo,
            difficulty: .intermediaire,
            questions: dermoQuestions,
            xpReward: 80,
            estimatedMinutes: 5,
            icon: "face.smiling.inverse"
        ),
        Quiz(
            id: UUID(),
            title: "Urgences au comptoir",
            description: "Reconnaitre les situations d'urgence a l'officine",
            category: .urgence,
            difficulty: .expert,
            questions: urgenceQuestions,
            xpReward: 120,
            estimatedMinutes: 6,
            icon: "cross.case.fill"
        ),
        Quiz(
            id: UUID(),
            title: "Legislation pharmaceutique",
            description: "Les regles juridiques de la dispensation",
            category: .legislation,
            difficulty: .avance,
            questions: legislationQuestions,
            xpReward: 100,
            estimatedMinutes: 6,
            icon: "building.columns.fill"
        ),
        Quiz(
            id: UUID(),
            title: "Micronutrition",
            description: "Vitamines, mineraux et complements alimentaires",
            category: .nutrition,
            difficulty: .intermediaire,
            questions: nutritionQuestions,
            xpReward: 80,
            estimatedMinutes: 5,
            icon: "fork.knife"
        ),
    ]

    // MARK: - Questions

    static let antibiotiquesQuestions: [Question] = [
        Question(id: UUID(), text: "Quelle famille d'antibiotiques comprend l'amoxicilline ?", type: .multipleChoice(choices: ["Macrolides", "Beta-lactamines", "Fluoroquinolones", "Aminosides"], correctIndex: 1), explanation: "L'amoxicilline est une penicilline, appartenant a la famille des beta-lactamines."),
        Question(id: UUID(), text: "L'azithromycine est un macrolide.", type: .trueFalse(correctAnswer: true), explanation: "L'azithromycine est bien un antibiotique de la famille des macrolides, utilise notamment dans les infections ORL et pulmonaires."),
        Question(id: UUID(), text: "Quel antibiotique est contre-indique chez l'enfant de moins de 8 ans ?", type: .multipleChoice(choices: ["Amoxicilline", "Doxycycline", "Azithromycine", "Cefpodoxime"], correctIndex: 1), explanation: "Les cyclines (dont la doxycycline) sont contre-indiquees chez l'enfant de moins de 8 ans en raison du risque de coloration des dents."),
        Question(id: UUID(), text: "Les fluoroquinolones peuvent provoquer des tendinopathies.", type: .trueFalse(correctAnswer: true), explanation: "Les fluoroquinolones sont effectivement associees a un risque de tendinite et de rupture du tendon d'Achille."),
        Question(id: UUID(), text: "Quelle est la duree standard d'une antibiotherapie par amoxicilline pour une angine ?", type: .multipleChoice(choices: ["3 jours", "5 jours", "6 jours", "10 jours"], correctIndex: 2), explanation: "Le traitement standard de l'angine a streptocoque par amoxicilline est de 6 jours."),
    ]

    static let conseilQuestions: [Question] = [
        Question(id: UUID(), text: "En cas de rhume, quel decongestionnant nasal ne doit pas etre utilise plus de 5 jours ?", type: .multipleChoice(choices: ["Serum physiologique", "Oxymetazoline", "Eau de mer hypertonique", "Fumigation"], correctIndex: 1), explanation: "Les vasoconstricteurs nasaux comme l'oxymetazoline ne doivent pas etre utilises plus de 5 jours pour eviter l'effet rebond."),
        Question(id: UUID(), text: "Le paracetamol peut etre pris a jeun.", type: .trueFalse(correctAnswer: true), explanation: "Contrairement aux AINS, le paracetamol peut etre pris a jeun car il n'est pas gastrotoxique."),
        Question(id: UUID(), text: "Quelle est la dose maximale quotidienne de paracetamol chez l'adulte ?", type: .multipleChoice(choices: ["2 g", "3 g", "4 g", "5 g"], correctIndex: 1), explanation: "La dose maximale est de 3 g/jour en automedication (4 g/jour sur prescription), avec un intervalle de 6h minimum entre les prises."),
        Question(id: UUID(), text: "Les AINS sont contre-indiques a partir du 6e mois de grossesse.", type: .trueFalse(correctAnswer: false), explanation: "Les AINS sont contre-indiques des le debut du 5e mois de grossesse (et non le 6e), soit a partir de 24 semaines d'amenorrhee."),
        Question(id: UUID(), text: "Quel conseil donner en priorite en cas de diarrhee aigue ?", type: .multipleChoice(choices: ["Prendre un antidiarrheique", "S'hydrater abondamment", "Jeuner 24 heures", "Prendre un antibiotique"], correctIndex: 1), explanation: "La rehydratation est la mesure prioritaire en cas de diarrhee aigue pour compenser les pertes hydro-electrolytiques."),
    ]

    static let ordonnanceQuestions: [Question] = [
        Question(id: UUID(), text: "Quelle est la duree de validite d'une ordonnance standard ?", type: .multipleChoice(choices: ["1 mois", "3 mois", "6 mois", "1 an"], correctIndex: 1), explanation: "Une ordonnance standard est valable 3 mois a compter de la date de prescription."),
        Question(id: UUID(), text: "Une ordonnance securisee est obligatoire pour les stupefiants.", type: .trueFalse(correctAnswer: true), explanation: "La prescription de stupefiants necessite obligatoirement une ordonnance securisee avec les posologies en toutes lettres."),
        Question(id: UUID(), text: "Quelle est la duree maximale de prescription des benzodiazepines hypnotiques ?", type: .multipleChoice(choices: ["2 semaines", "4 semaines", "8 semaines", "12 semaines"], correctIndex: 1), explanation: "Les benzodiazepines a visee hypnotique ne peuvent etre prescrites que pour 4 semaines maximum."),
        Question(id: UUID(), text: "Le pharmacien peut substituer un biosimilaire sans accord du prescripteur.", type: .trueFalse(correctAnswer: true), explanation: "Depuis 2022, le pharmacien peut substituer un medicament biologique par son biosimilaire en initiation de traitement."),
        Question(id: UUID(), text: "Combien de temps peut-on delivrer un traitement de stupefiants en une seule fois ?", type: .multipleChoice(choices: ["7 jours", "14 jours", "28 jours", "Selon le stupefiant"], correctIndex: 3), explanation: "La duree de delivrance depend du stupefiant : 7 jours pour le fentanyl, 14 jours pour la morphine orale, 28 jours pour la methadone gelules."),
    ]

    static let phytoQuestions: [Question] = [
        Question(id: UUID(), text: "Quelle plante est recommandee en cas de troubles du sommeil legers ?", type: .multipleChoice(choices: ["Ginseng", "Valeriane", "Guarana", "Ginkgo biloba"], correctIndex: 1), explanation: "La valeriane est traditionnellement utilisee pour faciliter l'endormissement et ameliorer la qualite du sommeil."),
        Question(id: UUID(), text: "Le millepertuis peut interagir avec de nombreux medicaments.", type: .trueFalse(correctAnswer: true), explanation: "Le millepertuis est un puissant inducteur enzymatique (CYP3A4) qui peut diminuer l'efficacite de nombreux medicaments (contraceptifs, anticoagulants, etc.)."),
        Question(id: UUID(), text: "Quelle plante est utilisee pour ses proprietes veinotoniques ?", type: .multipleChoice(choices: ["Vigne rouge", "Camomille", "Thym", "Eucalyptus"], correctIndex: 0), explanation: "La vigne rouge contient des anthocyanes et des tanins qui ameliorent la resistance des capillaires et le retour veineux."),
        Question(id: UUID(), text: "L'echinacee est utilisee pour prevenir les infections urinaires.", type: .trueFalse(correctAnswer: false), explanation: "L'echinacee est utilisee en prevention des infections des voies respiratoires superieures. Pour les infections urinaires, c'est la canneberge qui est recommandee."),
        Question(id: UUID(), text: "Quelle plante est traditionnellement utilisee contre le stress et l'anxiete ?", type: .multipleChoice(choices: ["Rhodiola", "Plantain", "Artichaut", "Fenouil"], correctIndex: 0), explanation: "La rhodiola est une plante adaptogene qui aide l'organisme a s'adapter au stress physique et mental."),
    ]

    static let dermoQuestions: [Question] = [
        Question(id: UUID(), text: "Quel SPF minimum est recommande pour une protection solaire efficace ?", type: .multipleChoice(choices: ["SPF 10", "SPF 20", "SPF 30", "SPF 50"], correctIndex: 2), explanation: "Un SPF 30 est le minimum recommande pour une protection efficace contre les UVB."),
        Question(id: UUID(), text: "L'acide hyaluronique est un agent hydratant qui capte l'eau.", type: .trueFalse(correctAnswer: true), explanation: "L'acide hyaluronique est un humectant capable de retenir jusqu'a 1000 fois son poids en eau, ce qui en fait un excellent hydratant."),
        Question(id: UUID(), text: "Quel actif est recommande en premiere intention contre l'acne legere ?", type: .multipleChoice(choices: ["Retinol", "Peroxyde de benzoyle", "Acide glycolique", "Niacinamide"], correctIndex: 1), explanation: "Le peroxyde de benzoyle est l'actif de premiere intention en cas d'acne legere grace a son action antibacterienne et keratolytique."),
        Question(id: UUID(), text: "Les emollients doivent etre appliques sur peau seche dans l'eczema.", type: .trueFalse(correctAnswer: false), explanation: "Les emollients s'appliquent idealement sur peau legerement humide (apres la douche) pour mieux retenir l'hydratation."),
        Question(id: UUID(), text: "Quel type de peau presente a la fois des zones seches et des zones grasses ?", type: .multipleChoice(choices: ["Peau seche", "Peau grasse", "Peau mixte", "Peau sensible"], correctIndex: 2), explanation: "La peau mixte se caracterise par une zone T (front, nez, menton) grasse et des joues normales a seches."),
    ]

    static let urgenceQuestions: [Question] = [
        Question(id: UUID(), text: "Quel signe doit faire suspecter un AVC ?", type: .multipleChoice(choices: ["Douleur thoracique", "Paralysie faciale soudaine", "Fievre elevee", "Eruption cutanee"], correctIndex: 1), explanation: "La paralysie faciale soudaine est un des signes cardinaux de l'AVC (FAST : Face, Arm, Speech, Time)."),
        Question(id: UUID(), text: "En cas de suspicion d'infarctus, il faut faire prendre de l'aspirine au patient.", type: .trueFalse(correctAnswer: true), explanation: "En attendant les secours, donner 300 mg d'aspirine a croquer (sauf allergie) est recommande en cas de suspicion d'infarctus."),
        Question(id: UUID(), text: "Quelle conduite tenir face a une reaction allergique avec oedeme de Quincke ?", type: .multipleChoice(choices: ["Donner un antihistaminique", "Appeler le 15 immediatement", "Appliquer de la glace", "Faire boire de l'eau"], correctIndex: 1), explanation: "L'oedeme de Quincke est une urgence vitale. Il faut appeler le 15 (SAMU) immediatement car il y a risque d'asphyxie."),
        Question(id: UUID(), text: "Un patient diabetique en hypoglycemie severe peut perdre connaissance.", type: .trueFalse(correctAnswer: true), explanation: "L'hypoglycemie severe peut entrainer une perte de connaissance, des convulsions et mettre en jeu le pronostic vital."),
        Question(id: UUID(), text: "Quel numero appeler en cas d'intoxication medicamenteuse ?", type: .multipleChoice(choices: ["Le 15 (SAMU)", "Le 18 (Pompiers)", "Le centre antipoison", "Le medecin traitant"], correctIndex: 2), explanation: "Le centre antipoison est le service specialise pour les intoxications. Il fournit des conseils de prise en charge adaptes au toxique ingere."),
    ]

    static let legislationQuestions: [Question] = [
        Question(id: UUID(), text: "Combien de temps faut-il conserver les copies d'ordonnances de stupefiants ?", type: .multipleChoice(choices: ["1 an", "3 ans", "5 ans", "10 ans"], correctIndex: 1), explanation: "Les copies d'ordonnances de stupefiants doivent etre conservees pendant 3 ans."),
        Question(id: UUID(), text: "Le pharmacien peut refuser de delivrer une ordonnance.", type: .trueFalse(correctAnswer: true), explanation: "Le pharmacien a le droit et le devoir de refuser la delivrance s'il estime que la prescription met en danger la sante du patient."),
        Question(id: UUID(), text: "Quelle est la liste des medicaments en acces direct ?", type: .multipleChoice(choices: ["Liste I", "Liste II", "Medicaments conseil", "Hors liste"], correctIndex: 2), explanation: "Les medicaments conseil (PMF - Prescription Medicale Facultative) peuvent etre places en acces direct devant le comptoir."),
        Question(id: UUID(), text: "La vente en ligne de medicaments sur ordonnance est autorisee en France.", type: .trueFalse(correctAnswer: false), explanation: "En France, seuls les medicaments sans ordonnance peuvent etre vendus en ligne par les pharmacies autorisees."),
        Question(id: UUID(), text: "Qui peut prescrire des medicaments en France ?", type: .multipleChoice(choices: ["Uniquement les medecins", "Medecins et sages-femmes", "Medecins, dentistes, sages-femmes et certains autres professionnels", "Tous les professionnels de sante"], correctIndex: 2), explanation: "Le droit de prescription est accorde aux medecins, dentistes, sages-femmes, et dans certaines conditions aux infirmiers, kinesitherapeutes et podologues."),
    ]

    static let nutritionQuestions: [Question] = [
        Question(id: UUID(), text: "Quelle vitamine est synthetisee par la peau sous l'effet du soleil ?", type: .multipleChoice(choices: ["Vitamine A", "Vitamine C", "Vitamine D", "Vitamine E"], correctIndex: 2), explanation: "La vitamine D est synthetisee par la peau sous l'effet des rayons UVB du soleil."),
        Question(id: UUID(), text: "Le fer d'origine animale (fer hemique) est mieux absorbe que le fer vegetal.", type: .trueFalse(correctAnswer: true), explanation: "Le fer hemique (viandes, poissons) a un taux d'absorption de 15-25% contre 2-5% pour le fer non hemique (vegetaux)."),
        Question(id: UUID(), text: "Quel mineral est souvent deficitaire chez les femmes en age de procreer ?", type: .multipleChoice(choices: ["Calcium", "Fer", "Zinc", "Selenium"], correctIndex: 1), explanation: "Le fer est le mineral le plus souvent deficitaire chez les femmes en age de procreer en raison des pertes menstruelles."),
        Question(id: UUID(), text: "La vitamine C ameliore l'absorption du fer.", type: .trueFalse(correctAnswer: true), explanation: "La vitamine C (acide ascorbique) favorise l'absorption du fer non hemique en le reduisant sous sa forme ferreuse, plus assimilable."),
        Question(id: UUID(), text: "Quelle est la dose journaliere recommandee de vitamine D chez l'adulte ?", type: .multipleChoice(choices: ["200 UI", "400 UI", "800 UI", "2000 UI"], correctIndex: 2), explanation: "Les recommandations actuelles suggerent 800 UI/jour de vitamine D chez l'adulte, avec des doses pouvant etre plus elevees en cas de carence."),
    ]

    // MARK: - Videos

    static let videos: [TrainingVideo] = [
        TrainingVideo(id: UUID(), title: "Entretien pharmaceutique : asthme", description: "Comment mener un entretien pharmaceutique sur l'asthme etape par etape", category: .conseil, duration: "12 min", thumbnailColor: .blue, isNew: true, difficulty: .intermediaire),
        TrainingVideo(id: UUID(), title: "Gestion des interactions", description: "Identifier et gerer les interactions medicamenteuses au comptoir", category: .medicaments, duration: "15 min", thumbnailColor: .red, isNew: true, difficulty: .avance),
        TrainingVideo(id: UUID(), title: "Delivrance des stupefiants", description: "Regles et bonnes pratiques pour la delivrance des stupefiants", category: .legislation, duration: "10 min", thumbnailColor: .orange, isNew: false, difficulty: .intermediaire),
        TrainingVideo(id: UUID(), title: "Les huiles essentielles", description: "Guide pratique des huiles essentielles les plus demandees", category: .phytotherapie, duration: "8 min", thumbnailColor: .green, isNew: false, difficulty: .debutant),
        TrainingVideo(id: UUID(), title: "Routine soin du visage", description: "Conseiller une routine adaptee selon le type de peau", category: .dermo, duration: "11 min", thumbnailColor: .pink, isNew: true, difficulty: .debutant),
        TrainingVideo(id: UUID(), title: "Les gestes d'urgence", description: "Les premiers gestes a adopter face a une urgence a l'officine", category: .urgence, duration: "14 min", thumbnailColor: .red, isNew: false, difficulty: .avance),
        TrainingVideo(id: UUID(), title: "Lire une analyse de sang", description: "Interpreter les principaux parametres d'une analyse sanguine", category: .conseil, duration: "18 min", thumbnailColor: .purple, isNew: false, difficulty: .intermediaire),
        TrainingVideo(id: UUID(), title: "Vaccination a l'officine", description: "Protocole complet de vaccination en pharmacie", category: .legislation, duration: "13 min", thumbnailColor: .teal, isNew: true, difficulty: .intermediaire),
    ]

    // MARK: - Leaderboard

    static let leaderboard: [LeaderboardEntry] = [
        LeaderboardEntry(id: UUID(), name: "Sophie M.", avatarEmoji: "👩‍⚕️", xp: 4520, level: 15, rank: .titulaire, streak: 21),
        LeaderboardEntry(id: UUID(), name: "Thomas R.", avatarEmoji: "👨‍⚕️", xp: 3890, level: 13, rank: .titulaire, streak: 14),
        LeaderboardEntry(id: UUID(), name: "Marie L.", avatarEmoji: "💊", xp: 3200, level: 11, rank: .adjoint, streak: 8),
        LeaderboardEntry(id: UUID(), name: "Lucas D.", avatarEmoji: "⚗️", xp: 2750, level: 10, rank: .adjoint, streak: 12),
        LeaderboardEntry(id: UUID(), name: "Camille B.", avatarEmoji: "🌿", xp: 2100, level: 8, rank: .adjoint, streak: 5),
        LeaderboardEntry(id: UUID(), name: "Antoine P.", avatarEmoji: "💉", xp: 1850, level: 7, rank: .preparateur, streak: 3),
        LeaderboardEntry(id: UUID(), name: "Julie F.", avatarEmoji: "🔬", xp: 1200, level: 5, rank: .preparateur, streak: 7),
        LeaderboardEntry(id: UUID(), name: "Maxime G.", avatarEmoji: "📋", xp: 800, level: 4, rank: .preparateur, streak: 2),
    ]

    // MARK: - Daily Challenges

    static let dailyChallenges: [DailyChallenge] = [
        DailyChallenge(id: UUID(), title: "Quiz du jour", description: "Completez un quiz aujourd'hui", xpReward: 50, icon: "questionmark.circle.fill", color: .blue, isCompleted: false),
        DailyChallenge(id: UUID(), title: "Video formation", description: "Regardez une video de formation", xpReward: 30, icon: "play.circle.fill", color: .red, isCompleted: false),
        DailyChallenge(id: UUID(), title: "Speed Quiz", description: "Faites un Speed Quiz", xpReward: 40, icon: "bolt.circle.fill", color: .orange, isCompleted: false),
    ]
}
