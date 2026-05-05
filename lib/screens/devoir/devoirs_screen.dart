import 'package:provider/provider.dart';
import 'package:syndory_etudiant/providers/devoir_provider.dart';
import 'package:syndory_etudiant/components/devoirs/devoirs_body.dart';
import 'package:syndory_etudiant/components/appNavbar.dart';

class DevoirsScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const DevoirsScreen({
    super.key, 
    this.navIndex = 0, 
    this.onNavTap,
  });

  @override
  State<DevoirsScreen> createState() => _DevoirsScreenState();
}

class _DevoirsScreenState extends State<DevoirsScreen> {
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    // Chargement initial des données via le provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DevoirProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevoirProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppNavbar(
        title: 'Mes Devoirs',
      ),
      body: DevoirsBody(
        activeTab: _activeTab,
        isLoading: provider.isLoading,
        errorMessage: provider.errorMessage,
        matieres: provider.matieres,
        onTabChanged: (index) => setState(() => _activeTab = index),
        onRefresh: () => provider.refresh(),
      ),
    );
  }
}