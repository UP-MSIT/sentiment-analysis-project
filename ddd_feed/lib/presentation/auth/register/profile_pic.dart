import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add a profile picture'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          children: [
            InkWell(
              onTap: () => showImageChoices(context),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Tap to add your profile picture',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text('done'.toUpperCase()),
                  ),
                ),
                onPressed: () => {}, //viewModel.uploadProfilePicture(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showImageChoices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Select from'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Ionicons.camera_outline),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // viewModel.pickImage(camera: true);
                },
              ),
              ListTile(
                leading: Icon(Ionicons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // viewModel.pickImage();
                  // viewModel.pickProfilePicture();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
