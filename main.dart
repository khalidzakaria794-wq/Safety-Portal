import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
bool backendReady = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    backendReady = true;
  }
  runApp(const SafetyPortalApp());
}

class SafetyPortalApp extends StatefulWidget {
  const SafetyPortalApp({super.key});
  @override
  State<SafetyPortalApp> createState() => _SafetyPortalAppState();
}

class _SafetyPortalAppState extends State<SafetyPortalApp> {
  bool isArabic = false;
  int selected = 0;
  final modules = const [
    ('Audits & Inspections', 'التفتيش والمراجعات', Icons.fact_check_outlined),
    ('Findings', 'الملاحظات والمخالفات', Icons.warning_amber_rounded),
    ('Risk Assessment', 'تقييم المخاطر', Icons.shield_outlined),
    ('Permits to Work', 'تصاريح العمل', Icons.assignment_turned_in_outlined),
    ('Training & Talks', 'التدريب واجتماعات السلامة', Icons.school_outlined),
    ('Safety Library', 'مكتبة السلامة', Icons.local_library_outlined),
  ];
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Safety Portal',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1f5f9f)), useMaterial3: true, scaffoldBackgroundColor: const Color(0xfff4f7fb)),
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const [Locale('en'), Locale('ar')],
    home: Directionality(textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr, child: home()),
  );
  Widget home() {
    final titles = isArabic ? ['الرئيسية','التطبيقات','طلباتي','حسابي'] : ['Home','Applications','My Requests','Profile'];
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Row(children: [Container(width: 36,height: 36,decoration: BoxDecoration(color: const Color(0xff1f5f9f),borderRadius: BorderRadius.circular(10)),child: const Center(child: Text('SP',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)))), const SizedBox(width: 10), const Text('Safety Portal',style: TextStyle(fontWeight: FontWeight.bold))]), actions: [TextButton(onPressed: () => setState(() => isArabic = !isArabic), child: Text(isArabic ? 'EN' : 'عربي')), const SizedBox(width: 8)]),
      body: selected == 3 ? profile() : selected == 2 ? requests() : selected == 1 ? applicationList() : dashboard(),
      bottomNavigationBar: NavigationBar(selectedIndex: selected, onDestinationSelected: (v)=>setState(()=>selected=v), destinations: [NavigationDestination(icon: const Icon(Icons.home_outlined),label: titles[0]),NavigationDestination(icon: const Icon(Icons.apps),label: titles[1]),NavigationDestination(icon: const Icon(Icons.inbox_outlined),label: titles[2]),NavigationDestination(icon: const Icon(Icons.person_outline),label: titles[3])]),
    );
  }
  Widget dashboard() => ListView(padding: const EdgeInsets.all(18), children: [Text(isArabic?'مرحباً بك في بوابة السلامة':'Welcome to Safety Portal',style: const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:6),Text(isArabic?'تابع عمليات السلامة من مكان واحد':'Your safety operations at a glance',style: const TextStyle(color:Colors.blueGrey)),const SizedBox(height:6),Text(backendReady ? (isArabic?'متصل بالخادم':'Backend configured') : (isArabic?'وضع العرض التجريبي - لم يتم ربط قاعدة البيانات':'Demo mode · backend not configured'),style: const TextStyle(fontSize:11,color:Colors.blueGrey)),const SizedBox(height:18),GridView.count(crossAxisCount:2,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),mainAxisSpacing:12,crossAxisSpacing:12,childAspectRatio:1.65,children:[stat(isArabic?'الطلبات المفتوحة':'Open Requests','12',Icons.inbox_outlined),stat(isArabic?'الملاحظات المفتوحة':'Open Findings','08',Icons.warning_amber),stat(isArabic?'عمليات التفتيش':'Audits','07',Icons.fact_check),stat(isArabic?'التنبيهات':'Alerts','03',Icons.notifications_none)]),const SizedBox(height:24),sectionTitle(isArabic?'التطبيقات':'Applications',()=>setState(()=>selected=1)),const SizedBox(height:12),...modules.take(4).map((m)=>moduleTile(m))]);
  Widget applicationList()=>ListView(padding:const EdgeInsets.all(18),children:[Text(isArabic?'التطبيقات':'Applications',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:14),...modules.map(moduleTile)]);
  Widget requests()=>ListView(padding:const EdgeInsets.all(18),children:[Text(isArabic?'طلباتي':'My Requests',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:14),requestTile('REQ-2026-001',isArabic?'طلب تصريح عمل':'Work permit request','Under review'),requestTile('REQ-2026-002',isArabic?'طلب معدات وقاية':'PPE equipment request','Approved'),requestTile('REQ-2026-003',isArabic?'طلب تدريب':'Training request','Submitted')]);
  Widget profile()=>ListView(padding:const EdgeInsets.all(18),children:[const CircleAvatar(radius:34,child:Icon(Icons.person,size:36)),const SizedBox(height:12),const Center(child:Text('Portal User',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),const SizedBox(height:24),ListTile(leading:const Icon(Icons.language),title:Text(isArabic?'اللغة':'Language'),subtitle:Text(isArabic?'العربية':'English'),onTap:()=>setState(()=>isArabic=!isArabic)),const ListTile(leading:Icon(Icons.security),title:Text('Security & Privacy')),const ListTile(leading:Icon(Icons.help_outline),title:Text('Help & Support'))]);
  Widget stat(String title,String value,IconData icon)=>Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Icon(icon,color:const Color(0xff1f5f9f)),Text(value,style:const TextStyle(fontSize:25,fontWeight:FontWeight.bold)),Text(title,style:const TextStyle(fontSize:12,color:Colors.blueGrey))]));
  Widget sectionTitle(String title,VoidCallback onTap)=>Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text(title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),TextButton(onPressed:onTap,child:Text(isArabic?'عرض الكل':'View all'))]);
  Widget moduleTile((String,String,IconData) m)=>Card(color:Colors.white,elevation:0,child:ListTile(leading:CircleAvatar(backgroundColor:const Color(0xffe8f1fa),child:Icon(m.$3,color:const Color(0xff1f5f9f))),title:Text(isArabic?m.$2:m.$1,style:const TextStyle(fontWeight:FontWeight.w600)),subtitle:Text(isArabic?m.$1:m.$2),trailing:const Icon(Icons.chevron_right),onTap:()=>showDialog(context:context,builder:(c)=>AlertDialog(title:Text(isArabic?m.$2:m.$1),content:Text(isArabic?'سيتم تفعيل هذه الوحدة عند ربط قاعدة البيانات.':'This module will be enabled when the backend is connected.'),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('OK'))]))));
  Widget requestTile(String id,String title,String status)=>Card(color:Colors.white,elevation:0,child:ListTile(title:Text(title),subtitle:Text(id),trailing:Chip(label:Text(status))));
}
