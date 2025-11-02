import 'package:flutter/material.dart';
import '../providers/app_data_provider.dart';
import 'package:provider/provider.dart';
import '../settings_page.dart';
import '../utils/helper_functions.dart';
import '../radio_group.dart' as app_radio;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    Provider.of<AppDataProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortingDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) => provider.hasDataLoaded
            ? provider.earthquakeModel!.features.isEmpty
                  ? const Center(child: Text('No record found'))
                  : ListView.builder(
                      itemCount: provider.earthquakeModel!.features.length,
                      itemBuilder: (context, index) {
                        final data = provider
                            .earthquakeModel!
                            .features[index]
                            .properties;
                        return ListTile(
                          title: Text(data.place),
                          subtitle: Text(
                            getFormattedDateTime(
                              data.time,
                              'EEE MMM dd yyyy hh:mm a',
                            ),
                          ),
                          trailing: Chip(
                            avatar: data.alert == null
                                ? null
                                : CircleAvatar(
                                    backgroundColor: provider.getAlertColor(
                                      data.alert!,
                                    ),
                                  ),
                            label: Text('${data.mag}'),
                          ),
                        );
                      },
                    )
            : const Center(child: Text('Please wait')),
      ),
    );
  }

  void _showSortingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort by'),
        content: Consumer<AppDataProvider>(
          builder: (context, provider, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              app_radio.RadioGroup(
                groupValue: provider.orderBy,
                value: 'magnitude',
                label: 'Magnitude-Desc',
                onChange: (value) {
                  provider.setOrder(value!);
                },
              ),
              app_radio.RadioGroup(
                groupValue: provider.orderBy,
                value: 'magnitude-asc',
                label: 'Magnitude-Asc',
                onChange: (value) {
                  provider.setOrder(value!);
                },
              ),
              app_radio.RadioGroup(
                groupValue: provider.orderBy,
                value: 'time',
                label: 'Time-Desc',
                onChange: (value) {
                  provider.setOrder(value!);
                },
              ),
              app_radio.RadioGroup(
                groupValue: provider.orderBy,
                value: 'time-asc',
                label: 'Time-Asc',
                onChange: (value) {
                  provider.setOrder(value!);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
