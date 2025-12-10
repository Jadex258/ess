import 'package:ess/enums/request_enums.dart';
import 'package:ess/models/request.dart';
import 'package:ess/screens/request/view_request.dart';
import 'package:ess/screens/request/create_request.dart';
import 'package:ess/services/request_service.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:ess/widgets/empty_widget.dart';
import 'package:ess/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class RequestListScreen extends StatelessWidget {
  const RequestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Requests',
        trailing: IconButton(
          icon: const Icon(Icons.add_comment, size: 26, color: Color(0xFF2896FD)),
          onPressed: () {
            pushWithoutNavBar(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreateRequestScreen(),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder<List<Request>>(
        stream: RequestService.streamMyRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(loadingText: "Getting requests...",);
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return EmptyWidget(
              title: 'No requests found.',
            );
          }

          final requests = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: requests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final request = requests[index];
              return _buildRequestItem(
                context,
                request: request,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRequestItem(BuildContext context, {required Request request}) {
    IconData iconData = Icons.thumb_up;
    Color statusColor;

    switch (request.status) {
      case RequestStatus.pending:
        iconData = Icons.watch_later;
        statusColor = const Color(0xFF3F51B5);
        break;
      case RequestStatus.rejected:
        iconData = Icons.thumb_down;
        statusColor = const Color(0xFFE53935);
        break;
      case RequestStatus.approved:
      iconData = Icons.thumb_up;
        statusColor = const Color(0xFF43A047);
        break;
    }

    String description =  request.data['reason'];

    return ListTile(
      onTap: () {
        pushWithoutNavBar(
          context,
          CupertinoPageRoute(
            builder: (context) => ViewRequestScreen(request: request),
          ),
        );
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
      minVerticalPadding: 0,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(iconData, size: 20, color: statusColor),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.type.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          if(description != '')
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
