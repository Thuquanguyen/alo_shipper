import 'package:flutter/material.dart';
import 'package:shipper/model/profile_model.dart';
import 'package:shipper/network/repository.dart';
import 'package:shipper/widget/circle_avatar_letter.dart';
import 'package:shipper/widget/state_builder.dart';

class ItemProfile extends StatelessWidget {
  ItemProfile({Key? key, this.profileModel}) : super(key: key);

  final DataProfile? profileModel;

  final StateHandler _stateHandler = StateHandler('HomeAdminScreen');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatarLetter(
                name: profileModel?.attributes?.fullName ?? '',
                size: 50,
                backgroundColor: Colors.grey.withOpacity(0.2),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileModel?.attributes?.userName ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(profileModel?.attributes?.fullName ?? ''),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      StateBuilder(
                          builder: () => Switch(
                                value: profileModel?.attributes?.status ==
                                    'ACTIVE',
                                onChanged: (value) {
                                  if (profileModel?.attributes?.status ==
                                      'ACTIVE') {
                                    Repository()
                                        .deActiveUser(
                                        profileModel
                                            ?.attributes?.userName ??
                                            '')
                                        .then((value) {
                                      profileModel?.attributes?.status = 'NORMAL';
                                      _stateHandler.refresh();
                                    });
                                  } else {
                                    Repository()
                                        .activeUser(
                                            profileModel
                                                    ?.attributes?.userName ?? '')
                                        .then((value) {
                                      profileModel?.attributes?.status = 'ACTIVE';
                                      _stateHandler.refresh();
                                    });
                                  }
                                },
                                activeTrackColor: Colors.grey.withOpacity(0.4),
                                activeColor: Colors.blue,
                              ),
                          routeName: "HomeAdminScreen"),
                    ],
                  ),
                  // Text(
                  //     '${profileModel?.attributes?.phone ?? ''} | ${profileModel?.attributes?.email ?? ''}')
                ],
              )),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
