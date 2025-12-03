class DDITestDataModel {
  final String drug1;
  final String drug2;
  final int interactionLevel;
  final String details;

  DDITestDataModel({
    required this.drug1,
    required this.drug2,
    required this.interactionLevel,
    required this.details,
  }) : assert(interactionLevel >= 0 && interactionLevel <= 5);
}

List<DDITestDataModel> ddITestData = [
  DDITestDataModel(
    drug1: 'الأسبرين',
    drug2: 'أيبوبروفين',
    interactionLevel: 4,
    details:
        'قد يؤدي تناول الإيبوبروفين بشكل دائم إلى إعاقة فعالية الأسبرين الإيجابية في تمييع الدم وحماية القلب، لذلك ينبغي الإمتناع عن التناول الدائم للإيبوبروفين لدى المرضى الذين يتلقون علاجًا بجرعات منخفضة من الأسبرين. من الممكن تناول الإيبوبروفين مرة واحدة، لكن عندها يجب تناول الدوائين بفارق زمني لا يقل عن ساعتين. إذا كان المريض يحتاج لعلاج دائم بمضاد إلتهاب لاستيرويدي (NSAID) يجب على الطبيب النظر في إعطاء دواء آخر أكثر مأمونية من هذه المجموعة، مثل: الديكْلوفيناك. كما ويجب الأخذ بالحسبان أن الدمج بين الأسبرين وبين مضادات الإلتهاب الاستيرويدية الأخرى يزيد من خطر حدوث التأثيرات الجانبية في الجهاز الهضمي.',
  ),
  DDITestDataModel(
    drug1: 'البروجسترون',
    drug2: 'الأنسولين',
    interactionLevel: 3,
    details:
        'يقل التأثير المخفض للسكر في الدم للأدوية المضادة للسكري، تشمل الإنسولين، عند دمجها مع البروجسترون. يجب مراقبة مستوى الجلوكوز في الدم بعناية عند دمج هذه الأدوية.',
  ),
  DDITestDataModel(
    drug1: 'أوميبرازول',
    drug2: 'دِيازيبام',
    interactionLevel: 3,
    details:
        'يؤدي الأوميبرازول (Omeprazole) الى زيادة مستويات الديازيبام (Diazepam) وزيادة تأثيره المهدئ. احتمال هذا التفاعل يكون اكبر بكثير عند العجائز. قد تكون الحاجة بتقليل جرعة الديازيبام، او النظر بإعطاء دواء اخر من عائلة البنزوديازيبينات (benzodiazepines) والذي لا يتفاعل مع الأوميبرازول، مثل: لورازيبام (Lorazepam) او أوكسازيبام (Oxazepam).',
  ),
  DDITestDataModel(
    drug1: 'إسيتالوبرام',
    drug2: 'كلونازيبام',
    interactionLevel: 0,
    details: 'لا يوجد تفاعلات بين الادوية في اللائحة',
  ),
  DDITestDataModel(
    drug1: 'ميرتازابين',
    drug2: 'إريثرومايسين',
    interactionLevel: 3,
    details:
        'قد يثبط الإريثروميسين (Erythromycin) من تحليل الميرتازابين (Mirtazapine) في الكبد، وبالتالي فانه يزيد من مستوياته في الدم ومن اعراضه الجانبية. يجب النظر في اعطاء جرعة قليلة جدا من الميرتازابين عند اعطاء هذين الدوائين معا. كذلك ينبغي فحص تأثير الميرتازابين عند اضافة / تقليل العلاج بالإريثروميسين، كما يجب ملائمة جرعة الميرتازابين.',
  ),
];

List<DDITestDataModel> ddITestDataInEnglish = [
  DDITestDataModel(
    drug1: 'Aspirin',
    drug2: 'ibuprofen',
    interactionLevel: 4,
    details:
        'Long-term use of ibuprofen may interfere with the positive blood-thinning and heart-protective effects of aspirin. Therefore, long-term ibuprofen use should be avoided in patients receiving low-dose aspirin therapy. Ibuprofen can be taken once daily, but the two medications should be taken at least two hours apart. If a patient requires long-term treatment with a nonsteroidal anti-inflammatory drug (NSAID), the doctor should consider prescribing a safer alternative, such as diclofenac. It should also be noted that combining aspirin with other NSAIDs increases the risk of gastrointestinal side effects.',
  ),
  DDITestDataModel(
    drug1: 'progesterone',
    drug2: 'insulin',
    interactionLevel: 3,
    details:
        'The blood sugar-lowering effect of antidiabetic drugs, including insulin, is reduced when combined with progesterone. Blood glucose levels should be carefully monitored when these drugs are used together.',
  ),
  DDITestDataModel(
    drug1: 'Omeprazole',
    drug2: 'Diazepam',
    interactionLevel: 3,
    details:
        'Omeprazole increases diazepam levels and its sedative effect. This interaction is much more likely in the elderly. It may be necessary to reduce the diazepam dose or consider giving another benzodiazepine that does not interact with omeprazole, such as lorazepam or oxazepam.',
  ),
  DDITestDataModel(
    drug1: 'escitalopram',
    drug2: 'Clonazepam',
    interactionLevel: 0,
    details: 'There are no drug interactions listed.',
  ),
  DDITestDataModel(
    drug1: 'Mirtazapine',
    drug2: 'Erythromycin',
    interactionLevel: 3,
    details:
        'Erythromycin may inhibit the metabolism of mirtazapine in the liver, thereby increasing its blood levels and side effects. A very low dose of mirtazapine should be considered when these two drugs are given together. The effect of mirtazapine should also be monitored when adding or reducing erythromycin therapy, and the mirtazapine dose should be adjusted accordingly.',
  ),
];
